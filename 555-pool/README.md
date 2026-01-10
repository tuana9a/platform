# pool

pool databases, message queues, caches or anything

# postgres cluster

I'm using patroni https://github.com/patroni/patroni/blob/3e3a4e134699154eb6fa8fc63f5d54d8256f1536/kubernetes/patroni_k8s.yaml

standby cluster

https://patroni.readthedocs.io/en/latest/standby_cluster.html

Ref: https://patroni.readthedocs.io/en/latest/kubernetes.html

# kafka cluster

powered by strimzi

```bash
curl "https://strimzi.io/install/latest?namespace=pool" -o strimzi-kafka-operator.yml
```

at this time `0.49.1` is the latest version
