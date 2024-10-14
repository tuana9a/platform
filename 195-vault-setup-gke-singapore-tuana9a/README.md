# vault

unseal

```bash
kubectl config use-context gke_tuana9a_asia-southeast1-a_zero
for vid in {0..2}; do
    for keyid in {0..2}; do
        kubectl -n vault exec vault-$vid -- vault operator unseal $(cat /tmp/vault-unseal.key.$keyid);
    done
done
```

first access test

```bash
export VAULT_ADDR=https://vault.tuana9a.com
vault login $(cat /tmp/vault.token.0)
```

terraform apply with root token (first time only) as we can create admin user later

```bash
export VAULT_ADDR=https://vault.tuana9a.com
vault login $(cat /tmp/vault.token.0)
terraform apply # yes
```

# ops

## user admin

create user admin

```bash
vault write auth/userpass/users/admin policies=auth-operator policies=sys-operator policies=secret-operator password=$(cat /tmp/vault.admin.pass)
```

login

```bash
vault login -method=userpass username=admin password=$(cat /tmp/vault.admin.pass)
```

## user secret-operator

create user secret-operator

```bash
vault write auth/userpass/users/secret-operator policies=secret-operator password=$(cat /tmp/vault.secret-operator.pass)
```

login

```bash
vault login -method=userpass username=secret-operator password=$(cat /tmp/vault.secret-operator.pass)
```
