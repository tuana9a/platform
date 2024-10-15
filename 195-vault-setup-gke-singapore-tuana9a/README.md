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

## approle secrets-operator

```bash
vault delete auth/approle/role/secrets-operator
```

```bash
vault write auth/approle/role/secrets-operator \
token_policies=secret-operator \
token_ttl=1h \
token_max_ttl=4h
```

```bash
vault read auth/approle/role/secrets-operator/role-id
vault read -field=role_id auth/approle/role/secrets-operator/role-id > /tmp/vault-approle.secrets-operator.role-id
```

```bash
vault write -f auth/approle/role/secrets-operator/secret-id
vault write -f -field=secret_id auth/approle/role/secrets-operator/secret-id > /tmp/vault-approle.secrets-operator.secret-id
```

```bash
vault write auth/approle/login \
role_id=$(cat /tmp/vault-approle.secrets-operator.role-id) \
secret_id=$(cat /tmp/vault-approle.secrets-operator.secret-id)
```

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
