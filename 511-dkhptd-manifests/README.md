# dkhptd

```bash
kubectl -n dkhptd port-forward svc/mongo --address ${address:-0.0.0.0} ${port:-27017}:27017
```

```bash
kubectl -n dkhptd port-forward svc/rabbitmq --address ${address:-0.0.0.0} ${port:-15672}:15672
```
