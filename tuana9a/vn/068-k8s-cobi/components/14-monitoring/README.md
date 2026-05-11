# loki

```promql
sum by (namespace) (count_over_time({namespace=~".+"} [1h]))
```

# promtail

# prometheus

```bash
kubectl -n prometheus port-forward svc/prometheus-server --address ${address:-0.0.0.0} ${port:-9090}:80
```

# grafana

we use sidecar to pickup configmap with specific label to configure datasource and dashboard

how-to port-forward

```bash
kubectl -n grafana port-forward svc/grafana --address ${address:-0.0.0.0} ${port:-3000}:80
```

how-to get admin password

```bash
kubectl -n grafana get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

or

```bash
kubectl -n grafana get secret admin-login -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

how-to reset admin password

```bash
grafana cli --homepath "/usr/share/grafana/" admin reset-admin-password $(cat /tmp/password)
```

dashboards

- node-exporter-full: 1860
- kube-state-metrics-v2: 21742

# alertmanager

test alert

```bash
uid=$RANDOM
alertname=test-alert-$uid
kubectl -n prometheus run $alertname --rm -i --tty --restart='Never' --image=alpine/curl -- curl -H 'Content-Type: application/json' -d '[{"labels":{"alertname":"'$alertname'"},"annotations":{"alertname":"'$alertname'"}}]' http://alertmanager:9093/api/v2/alerts
echo $alertname
```

## known-issues

There is an error with `webhook_discord_url` with version `< 0.28`

https://github.com/prometheus/alertmanager/pull/3728
