# calico

WHAT A STUPID CNI INSTALLATION
- fragile: so easy to mesh up
- zero self-healing: can not recover itself when re-install
- no clean uninstallation: leaving trash behind breaking other stuffs

```bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/operator-crds.yaml
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/tigera-operator.yaml
```

```bash
curl -O https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/custom-resources-bpf.yaml
```

```bash
kubectl apply -f custom-resources-bpf.yaml
```

```bash
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/operator-crds.yaml
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.31.4/manifests/tigera-operator.yaml
```
