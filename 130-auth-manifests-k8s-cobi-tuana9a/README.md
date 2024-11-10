# oidc k8s authentication

Install kubelogin https://github.com/int128/kubelogin

Add new user in `kubeconfig`

```yaml
users:
  - name: oidc
    user:
      exec:
        apiVersion: client.authentication.k8s.io/v1beta1
        args:
          - oidc-login
          - get-token
          - --oidc-issuer-url=https://accounts.google.com
          - --oidc-client-id=
          - --oidc-client-secret=
          - --skip-open-browser
        command: kubectl
        env: null
        interactiveMode: IfAvailable
        provideClusterInfo: false
```

Edit static pod `kube-apiserver.yml`, add 2 flags for oidc

```yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - ...
    - --oidc-issuer-url=https://accounts.google.com
    - --oidc-client-id=
```

Get the user with this format (ISSUER_URL#ACCOUNT_ID)

```bash
kubectl auth whoami
```

Make that into your role binding

```yaml
apiVersion: rbac.authorization.k8s.io/v1
# This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
kind: ClusterRoleBinding
metadata:
  name: cluser-admin-tuana9a
subjects:
  - kind: User
    name: https://accounts.google.com#accountid
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
```

# k8s-ingress-lb

How-to: https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#normal-user

```bash
username=k8s-ingress-lb
openssl genrsa -out $username.key 2048
openssl req -new -key $username.key -out $username.csr -subj "/CN=$username"
```

```bash
csr_base64=$(cat $username.csr | base64 | tr -d "\n")
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $username
spec:
  request: $csr_base64
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 31556952  # one year
  usages:
  - client auth
EOF
```

```bash
kubectl certificate approve $username
kubectl get csr $username -o jsonpath='{.status.certificate}'| base64 -d > $username.crt
```

```bash
cat $username.key | base64 | tr -d "\n"
cat $username.crt | base64 | tr -d "\n"
```
