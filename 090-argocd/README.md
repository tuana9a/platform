# argocd

apply

```bash
terraform init
```

```bash
terraform apply
```

get argocd admin password

```bash
argocd admin initial-password -n argocd
```

port forward for argocd access from dev machine
- terraform apply
- web ui access

```bash
kubectl -n argocd port-forward svc/argocd-server --address ${address:-0.0.0.0} ${port:-8443}:443
```
