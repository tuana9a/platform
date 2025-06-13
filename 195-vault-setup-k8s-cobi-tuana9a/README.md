# vault

# unseal

```bash
for vid in {0..2}; do
    for keyid in {0..2}; do
        kubectl -n vault exec vault-$vid -- vault operator unseal $(cat /tmp/vault-unseal.key.$keyid);
    done
done
```

# first access test

```bash
export VAULT_ADDR=https://vault.tuana9a.com
vault login $(cat /path/to/secret)
```

terraform apply with root token (first time only) as we can create admin user later

```bash
export VAULT_ADDR=https://vault.tuana9a.com
vault login $(cat /path/to/secret)
terraform apply # yes
```

# user management

```bash
# user admin
vault write auth/userpass/users/admin policies=auth-operator policies=sys-operator policies=secret-operator password=$(cat /path/to/secret)
vault login -method=userpass username=admin password=$(cat /path/to/secret)
```

```bash
# user secret-operator
vault write auth/userpass/users/secret-operator policies=secret-operator password=$(cat /path/to/secret)
vault login -method=userpass username=secret-operator password=$(cat /path/to/secret)
```
