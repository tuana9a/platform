# knative

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