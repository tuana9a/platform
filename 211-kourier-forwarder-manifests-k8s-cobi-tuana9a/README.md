# why kourier forwarder

- knative use kourier as ingress
- kourier service is living on namespace: `knative-serving`
- but I'm using ingress nginx
- so the idea is in each namespace that use knative, create a service that forward to kourier service in ns `knative-serving`

```yaml
kind: Service
apiVersion: v1
metadata:
  name: forward-kourier
  namespace: $ns
spec:
  type: ExternalName
  externalName: kourier-internal.knative-serving.svc.cluster.local
  ports:
    - port: 80
```
