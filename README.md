# platform

tuana9a's platform
- configuration as code (asnible)
- infrastructure as code (terraform)
- deploy apps (argocd)
- physical infra (proxmox)
- cloud infra (aws, cloudflare)
- dns, cdn, web (cloudflare)
- load balancer, reverse proxy (haproxy, nginx)

# infra

Install `gcloud` cli, then

```
gcloud auth application-default login
```

Proxmox: [Set up OpenID Connect for Google Login](https://forum.proxmox.com/threads/mobile-web-and-android-app-how-to-log-in-with-google-oauth2-openid.116234/post-563563)

# configuration as code

## prepare ansible

NOTE: using python of the os, change the 3.10 if necessary

```bash
sudo -i
apt install -y python3.10-venv
mkdir -p /opt/ansible
cd /opt/ansible
python3 -m venv .venv
source .venv/bin/activate
pip install ansible ansible-core ansible-lint
ln -sf /opt/ansible/.venv/bin/ansible* /usr/local/bin
```

verify ansible installation

```bash
ansible --version
```

config ansible (optional)

```bash
ln -sf $PWD/ansible.cfg ~/.ansible.cfg
ln -sf $PWD/secrets/ansible-vault-password.txt ~/.ansible-vault-password.txt
```

# deploy apps (argocd)

get argocd admin password

```bash
argocd admin initial-password -n argocd
```

port forward for argocd access from dev machine
- terraform apply
- web ui access

```bash
kubectl -n argocd port-forward svc/argocd-server --address ${address:-0.0.0.0} ${port:-8443}:443
```

# logging EFK (deleted)

- elasticsearch
- fluentd
- kibana

```bash
kubectl -n efk port-forward svc/kibana --address ${address:-0.0.0.0} ${port:-5601}:5601
```

```bash
kubectl -n efk port-forward svc/elasticsearch --address ${address:-0.0.0.0} ${port:-9200}:9200
```

# monitoring

- prometheus
- grafana

```bash
kubectl -n prometheus port-forward svc/grafana --address ${address:-0.0.0.0} ${port:-3000}:80
```

```bash
kubectl -n prometheus port-forward svc/prometheus-server --address ${address:-0.0.0.0} ${port:-9090}:80
```
