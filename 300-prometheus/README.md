# prometheus

```bash
kubectl -n prometheus port-forward svc/prometheus-server --address ${address:-0.0.0.0} ${port:-9090}:80
```
