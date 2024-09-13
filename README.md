# platform

tuana9a's platform
- configuration as code (asnible)
- infrastructure as code (terraform)
- deploy apps (argocd)
- infra (aws, proxmox)
- dns, cdn, web (cloudflare)
- load balancer, reverse proxy (haproxy, nginx)

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
ln -sf $PWD/ansible.cfg ~/.ansible.cfg
ln -sf $PWD/secrets/ansible-vault-password.txt ~/.ansible-vault-password.txt
```
