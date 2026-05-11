# cert-manager

https://cert-manager.io/docs/concepts/issuer/

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

# cilium

cilium comes in after 2 days strugling with calico cni.

## kubeproxy free

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

## change pod cidr

- uninstall cilium
- delete ciliumnode
- rollout replace node

# flannel

## Working with iptables

To see every thing

```bash
iptables-save
```

And to see only table names:

```bash
iptables-save | grep '^*'
```

See some flannel stuffs

```bash
iptables -t nat -L
```

An example route grafana service
- 10.233.208.212:80 -> 10.244.9.102:3000

```js
Chain KUBE-SERVICES (2 references)
target     prot opt source               destination         
KUBE-SVC-FQRDHG6MUQQJ56BJ  tcp  --  anywhere             10.233.208.212       /* grafana/grafana:service cluster IP */ tcp dpt:http
```

```js
Chain KUBE-SVC-FQRDHG6MUQQJ56BJ (1 references)
target     prot opt source               destination         
KUBE-MARK-MASQ  tcp  -- !10.244.0.0/16        10.233.208.212       /* grafana/grafana:service cluster IP */ tcp dpt:http
KUBE-SEP-GAZ5UDV6NTJ25A3T  all  --  anywhere             anywhere             /* grafana/grafana:service -> 10.244.9.102:3000 */
```

```js
Chain KUBE-SEP-GAZ5UDV6NTJ25A3T (1 references)
target     prot opt source               destination         
KUBE-MARK-MASQ  all  --  10.244.9.102         anywhere             /* grafana/grafana:service */
DNAT       tcp  --  anywhere             anywhere             /* grafana/grafana:service */ tcp to:10.244.9.102:3000
```

## Cleanup flannel

See [../068-k8s-cobi-tuana9a/README.md#cleanup-flannel](../068-k8s-cobi-tuana9a/README.md#cleanup-flannel)