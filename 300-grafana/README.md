# grafana

we use sidecar to pickup configmap with specific label to configure datasource and dashboard

port-forward

```bash
kubectl -n grafana port-forward svc/grafana --address ${address:-0.0.0.0} ${port:-3000}:80
```

get admin password

```bash
kubectl -n grafana get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

reset admin password

```bash
grafana cli --homepath "/usr/share/grafana/" admin reset-admin-password $(cat /tmp/password)
```

# dashboards

## node-exporter-full

1860

## kube-state-metrics-v2:

21742
