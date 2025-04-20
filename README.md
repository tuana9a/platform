# platform

tuana9a's platform

- configuration as code: asnible
- infrastructure as code: terraform
- deploy apps, cd: argocd
- cloud providers: aws, gcp, proxmox
- dns, cdn, web: cloudflare
- load balancer, reverse proxy: haproxy, nginx

# How-to

## gcloud

setup `gcloud` cli auth

```bash
gcloud auth application-default login
```

## python env

NOTE: using python of the os, change the 3.10 if necessary

```bash
sudo apt install -y python3.10-venv
cd ~
python3 -m venv .venv
source .venv/bin/activate
pip list
```

## ansible

using python env from previous step

```bash
cd ~
source .venv/bin/activate
pip install ansible ansible-core ansible-lint
ln -sf ~/.venv/bin/ansible* ~/.local/bin/
```

verify ansible installation

```bash
ansible --version
```

## python formatter

using python env from previous step

```bash
cd ~
source .venv/bin/activate
pip install black
ln -sf ~/.venv/bin/black ~/.local/bin/
```
