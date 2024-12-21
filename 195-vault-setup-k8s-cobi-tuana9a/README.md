# vault

first access test

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

## user admin

create user admin

```bash
vault write auth/userpass/users/admin policies=auth-operator policies=sys-operator policies=secret-operator password=$(cat /path/to/secret)
```

login

```bash
vault login -method=userpass username=admin password=$(cat /path/to/secret)
```

## user secret-operator

create user secret-operator

```bash
vault write auth/userpass/users/secret-operator policies=secret-operator password=$(cat /path/to/secret)
```

login

```bash
vault login -method=userpass username=secret-operator password=$(cat /path/to/secret)
```
