# platform

tuana9a's platform

# prepare ansible

NOTE: using python of the os, change the 3.10

```bash
apt install python3.10-venv
```

```bash
sudo -i
mkdir -p /opt/ansible
cd /opt/ansible
python3 -m venv .venv
source .venv/bin/activate
pip install ansible ansible-core ansible-lint
ln -sf /opt/ansible/.venv/bin/ansible* /usr/local/bin
```