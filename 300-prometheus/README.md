# prometheus

```bash
kubectl -n prometheus port-forward svc/prometheus-server --address ${address:-0.0.0.0} ${port:-9090}:80
```

test alert

```bash
kubectl -n prometheus run test-alert --rm -i --tty --restart='Never' --image=alpine/curl -- curl -H 'Content-Type: application/json' -d '[{"labels":{"alertname":"test'$RANDOM'"},"annotations":{"alertname":"test'$RANDOM'"}}]' http://prometheus-alertmanager:9093/api/v2/alerts
```