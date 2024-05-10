# platform

tuana9a's platform
- configuration as code (asnible)
- infrastructure as code (terraform)
- deploy apps (argocd)
- physical infra (proxmox)
- cloud infra (aws, cloudflare)
- dns, cdn, web (cloudflare)
- load balancer, reverse proxy (haproxy, nginx)

# configuration as code

## prepare ansible

NOTE: using python of the os, change the 3.10 if necessary

```bash
apt install python3.10-venv
sudo -i
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