# coder

```bash
kubectl -n coder port-forward svc/postgres --address ${address:-0.0.0.0} ${port:-5432}:5432
```
