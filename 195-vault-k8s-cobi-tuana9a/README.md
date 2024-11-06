# vault

https://developer.hashicorp.com/vault/tutorials/kubernetes/kubernetes-minikube-raft

# unseal

```bash
for vid in {0..2}; do
    for keyid in {0..2}; do
        kubectl -n vault exec vault-$vid -- vault operator unseal $(cat /tmp/vault-unseal.key.$keyid);
    done
done
```
