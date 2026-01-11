# knative

<https://knative.dev/docs/install/operator/knative-with-operators/>

```bash
wget https://github.com/knative/operator/releases/download/knative-v1.14.4/operator.yaml -O operator.yaml
```

# enable volume if needed

by default knative not support volume, need to enabled it with <https://knative.dev/docs/serving/services/storage/>

```bash
kubectl patch --namespace knative-serving configmap/config-features --type merge --patch '{"data":{"kubernetes.podspec-persistent-volume-claim": "enabled", "kubernetes.podspec-persistent-volume-write": "enabled"}}'
```

get namespaces except knative

```bash
kubectl get ns -o jsonpath='{.items[*].metadata.name}' | sed 's/ /\n/g' | grep -v knative
```

# Refs

https://knative.dev/docs/install/operator/configuring-eventing-cr/
