# platform

tuana9a's platform
- configuration as code (asnible)
- infrastructure as code (terraform)
- deploy apps (argocd)
- infra (aws, proxmox)
- dns, cdn, web (cloudflare)
- load balancer, reverse proxy (haproxy, nginx)

# dependency graph

```mermaid
graph TD;
    argocd-->apps;
    argocd-->promtail;
    argocd-->cert-manager;
    argocd-->external-dns;
    argocd-->grafana;
    argocd-->ingress;
    argocd-->knative;
    argocd-->prometheus;
    argocd-->loki;
    argocd-->metallb;
    argocd-->metrics-server;
    argocd-->coder;
    argocd-->nfs-provisioner;
    cert-manager-->apps;
    external-dns-->apps;
    flannel-->argocd;
    ingress-->apps;
    knative-->apps;
    loki-->grafana;
    loki-->promtail;
    metallb-->ingress;
    nfs-provisioner-->coder;
    nfs-provisioner-->apps;
    nfs-provisioner-->grafana;
    nfs-provisioner-->loki;
    nfs-provisioner-->prometheus;
    prometheus-->grafana;
```

# gcloud

setup `gcloud` cli auth

```
gcloud auth application-default login
```

# ansible

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
vim ~/.ansible.cfg
```

```conf
[defaults]
vault_password_file=~/.ansible-vault-password
```
