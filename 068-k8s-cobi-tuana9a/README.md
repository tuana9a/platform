# k8s-cobi-tuana9a

# oidc - Login with Google

```bash
kubectl -n kube-system edit cm kubeadm-config
```

add two keys to kube-apiserver flags

- `oidc-issuer-url`
- `oidc-client-id`

```yaml
apiVersion: v1
data:
  ClusterConfiguration: |
    apiServer:
      extraArgs:
        oidc-issuer-url: https://accounts.google.com
        oidc-client-id: xxx-yyy.apps.googleusercontent.com
```
