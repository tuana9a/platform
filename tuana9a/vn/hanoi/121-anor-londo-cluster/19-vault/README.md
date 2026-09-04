# vault

https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-raft

# backup and restore

```bash
kubectl -n vault cp /tmp/vault.snap vault-0:/tmp/vault.snap
```

```bash
kubectl -n vault exec -it vault-0 -- sh
```

```bash
vault operator init \
    -key-shares=3 \
    -key-threshold=3 \
    -format=json > /tmp/cluster-keys.json
```

get the unseal key(s) from `/tmp/cluster-keys.json`

```bash
vault operator unseal
```

```bash
export VAULT_TOKEN=$(jq -r ".root_token" /tmp/cluster-keys.json)
```

```bash
vault operator raft snapshot restore -force /tmp/vault.snap
```

get into other vault instances and join the `vault-0`

```bash
kubectl -n vault exec -ti vault-1 -- vault operator raft join http://vault-0.vault-internal:8200
```

```bash
kubectl -n vault exec -ti vault-2 -- vault operator raft join http://vault-0.vault-internal:8200
```