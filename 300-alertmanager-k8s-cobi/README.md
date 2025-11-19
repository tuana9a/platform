# alertmanager

test alert

```bash
uid=$RANDOM
alertname=test-alert-$uid
kubectl -n prometheus run $alertname --rm -i --tty --restart='Never' --image=alpine/curl -- curl -H 'Content-Type: application/json' -d '[{"labels":{"alertname":"'$alertname'"},"annotations":{"alertname":"'$alertname'"}}]' http://alertmanager:9093/api/v2/alerts
echo $alertname
```
