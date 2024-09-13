# efk

`kubectl apply` in ascending order of number

- elasticsearch
- fluentd
- kibana

```bash
kubectl -n efk port-forward svc/kibana --address ${address:-0.0.0.0} ${port:-5601}:5601
```

```bash
kubectl -n efk port-forward svc/elasticsearch --address ${address:-0.0.0.0} ${port:-9200}:9200
```
