# grafana

port-forward

```bash
kubectl -n grafana port-forward svc/grafana --address ${address:-0.0.0.0} ${port:-3000}:80
```

get admin password

```bash
kubectl -n grafana get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
