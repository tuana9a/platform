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
