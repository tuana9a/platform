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

```bash
kubectl -n pool run kafka-producer -ti --image=quay.io/strimzi/kafka:0.49.1-kafka-4.1.1 --rm=true --restart=Never -- bin/kafka-console-producer.sh --bootstrap-server kk-red-kafka-bootstrap:9092 --topic my-topic
```

```bash
kubectl -n pool run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.49.1-kafka-4.1.1 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server kk-red-kafka-bootstrap:9092 --topic my-topic --from-beginning
```

```bash
kubectl -n pool run debug -ti --image=quay.io/strimzi/kafka:0.49.1-kafka-4.1.1 --rm=true --restart=Never -- bash
```

```bash
bin/kafka-groups.sh --bootstrap-server kk-red-kafka-bootstrap:9092 --list
bin/kafka-consumer-groups.sh --bootstrap-server kk-red-kafka-bootstrap:9092 --describe --group console-consumer-97662
```

refs:
- https://strimzi.io/quickstarts/
- https://github.com/strimzi/strimzi-kafka-operator/blob/0.49.1/examples/kafka/kafka-single-node.yaml