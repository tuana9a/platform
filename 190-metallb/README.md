# metallb

I used to make metallb as argo app but it's showing diff, and I think this lb is critical so I prefered manual work atm.

```bash
terraform init
terraform apply
kubectl apply -f vmbr56-IPAddressPool.yaml
kubectl apply -f vmbr56-L2Advertisement.yaml
```
