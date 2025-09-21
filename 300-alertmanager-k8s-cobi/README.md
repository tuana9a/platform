# alertmanager

test alert

```bash
kubectl -n prometheus run test-alert --rm -i --tty --restart='Never' --image=alpine/curl -- curl -H 'Content-Type: application/json' -d '[{"labels":{"alertname":"test'$RANDOM'"},"annotations":{"alertname":"test'$RANDOM'"}}]' http://alertmanager:9093/api/v2/alerts
```
