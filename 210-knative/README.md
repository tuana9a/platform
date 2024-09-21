# knative

UPDATE: this stack is now managed by argocd

https://knative.dev/docs/install/operator/knative-with-operators/#create-the-knative-serving-custom-resource

```bash
kubectl apply -f https://github.com/knative/operator/releases/download/knative-v1.14.4/operator.yaml
```

```bash
kubectl apply -f knative-serving.yml
```

```bash
kubectl apply -f knative-eventing.yml
```

by default knative not support volume, need to enabled it with https://knative.dev/docs/serving/services/storage/

```bash
kubectl patch --namespace knative-serving configmap/config-features --type merge --patch '{"data":{"kubernetes.podspec-persistent-volume-claim": "enabled", "kubernetes.podspec-persistent-volume-write": "enabled"}}'
```
