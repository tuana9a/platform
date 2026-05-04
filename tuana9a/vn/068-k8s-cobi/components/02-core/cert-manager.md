# cert-manager

## known issues

https://github.com/cert-manager/cert-manager/issues/7138

webhook ca cert is expired

```bash
kubectl get secret -n cert-manager cert-manager-webhook-ca -ojsonpath='{.data.ca\.crt}' | base64 -d > tmp.crt
openssl x509 -text -noout -in tmp.crt
```

solution

```bash
kubectl delete -n cert-manager secret cert-manager-webhook-ca
```
