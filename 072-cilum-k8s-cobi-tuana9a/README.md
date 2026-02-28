# cilium

cilium comes in after 2 days strugling with calico cni.

# what did I do

removal of kube-proxy as result of me meshing up with calico and don't know how to recovery kubeproxy

https://docs.cilium.io/en/stable/network/kubernetes/kubeproxy-free/

```bash
kubectl -n kube-system delete ds kube-proxy
# Delete the configmap as well to avoid kube-proxy being reinstalled during a Kubeadm upgrade
kubectl -n kube-system delete cm kube-proxy
```

```bash
# Run on each node with root permissions:
iptables-save | grep -v KUBE | iptables-restore
```

then I install cilium just with helm with these values

```yml
kubeProxyReplacement: true
k8sServiceHost: 192.168.56.21
k8sServicePort: 6443
```
