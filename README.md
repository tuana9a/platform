# platform

tuana9a's platform

- CaC: `ansible`
- IaC: `terraform`
- cicd: `argocd`, `github-workflow`, `Jenkins`
- cloud: `aws`, `gcp`, `proxmox`
- dns, cdn, web: `cloudflare`
- lb, web, proxy: `haproxy`, `nginx`

# gcloud

setup `gcloud` cli auth

```bash
gcloud auth application-default login
```

# global python

NOTE: using python of the os, change the 3.10 if necessary

```bash
sudo apt install -y python3.10-venv
python3 -m venv ~/.venv
source ~/.venv/bin/activate
pip list
```

python formatter

```bash
source ~/.venv/bin/activate
pip install black
ln -sf ~/.venv/bin/black ~/.local/bin/
```

# ansible

require [global-python](#global-python)

using python env from previous step

```bash
source ~/.venv/bin/activate
pip install ansible ansible-core ansible-lint
ln -sf ~/.venv/bin/ansible* ~/.local/bin/
```

verify ansible installation

```bash
ansible --version
```
