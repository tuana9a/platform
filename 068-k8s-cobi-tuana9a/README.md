# k8s-cobi-tuana9a

# oidc - Login with Google

add two keys to kube-apiserver flags

- `oidc-issuer-url`
- `oidc-client-id`

```bash
kubectl -n kube-system edit cm kubeadm-config
```

```yaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      extraArgs:
        oidc-issuer-url: https://accounts.google.com
        oidc-client-id: xxx-yyy.apps.googleusercontent.com
```

# changing diskpresure threshold

https://kubernetes.io/docs/reference/config-api/kubelet-config.v1beta1/#kubelet-config-k8s-io-v1beta1-KubeletConfiguration

https://kubernetes.io/docs/concepts/scheduling-eviction/node-pressure-eviction/

```bash
kubectl -n kube-system edit cm kubelet-config
```

```yaml
apiVersion: v1
data:
  kubelet: |
    evictionHard:
      nodefs.available: "2Gi"
```

# tunning

nodelocaldns: https://kubernetes.io/docs/tasks/administer-cluster/nodelocaldns

etcd: https://etcd.io/docs/v3.5/tuning/

# cleanup flannel

https://stackoverflow.com/questions/46276796/kubernetes-cannot-cleanup-flannel

```bash
kubeadm reset
```

```bash
rm -r /var/lib/cni/
rm -r /run/flannel
rm -r /etc/cni/
```

```bash
ip link
```

```bash
ip link delete cni0
ip link delete flannel.1
```

```bash
systemctl restart containerd
systemctl restart kubelet
```

# unknown systemd-resolved uninstalled, resolvconf installed

somehow systemd-resolved got uninstalled, need to install systemd-resolved again

and uninstall, purge resolvconf

LOL

# administration

## remove control plane

first remove etcd member


```bash
ssh i-123
```

```bash
ETCDCTL_CACERT="/etc/kubernetes/pki/etcd/ca.crt"
ETCDCTL_CERT="/etc/kubernetes/pki/apiserver-etcd-client.crt"
ETCDCTL_KEY="/etc/kubernetes/pki/apiserver-etcd-client.key"
host=192.168.56.23
ETCDCTL_OPTS="--endpoints=$host:2379 --cacert=$ETCDCTL_CACERT --cert=$ETCDCTL_CERT --key=$ETCDCTL_KEY"
```

```bash
ETCDCTL_API=3 etcdctl $ETCDCTL_OPTS member list
```

```txt
213e14a22f76956b, started, i-123, https://192.168.56.23:2380, https://192.168.56.23:2379, false
8e11ebdb35be1924, started, i-124, https://192.168.56.24:2380, https://192.168.56.24:2379, false
99788e30c04d918b, started, i-125, https://192.168.56.25:2380, https://192.168.56.25:2379, false
```

remove by member id

```bash
ETCDCTL_API=3 etcdctl $ETCDCTL_OPTS member remove 99788e30c04d918b
ETCDCTL_API=3 etcdctl $ETCDCTL_OPTS member remove 8e11ebdb35be1924
```

drain the node

```bash
kubectl drain --ignore-daemonsets --delete-emptydir-data --disable-eviction --force i-124
kubectl drain --ignore-daemonsets --delete-emptydir-data --disable-eviction --force i-125
```

delete the node

```bash
kubectl delete node i-124
kubectl delete node i-125
```

ssh i-124,i-125

```bash
kubeadm reset -f
```

remove the vm later
