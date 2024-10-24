# oidc k8s authentication

Install kubelogin https://github.com/int128/kubelogin

Add new user in `kubeconfig`

```yaml
users:
  - name: oidc
    user:
      exec:
        apiVersion: client.authentication.k8s.io/v1beta1
        args:
          - oidc-login
          - get-token
          - --oidc-issuer-url=https://accounts.google.com
          - --oidc-client-id=
          - --oidc-client-secret=
          - --skip-open-browser
        command: kubectl
        env: null
        interactiveMode: IfAvailable
        provideClusterInfo: false
```

Edit static pod `kube-apiserver.yml`, add 2 flags for oidc

```yaml
spec:
  containers:
  - command:
    - kube-apiserver
    - ...
    - --oidc-issuer-url=https://accounts.google.com
    - --oidc-client-id=474326114337-h9kpe020anghtfn8450knt6ltnqnar3t.apps.googleusercontent.com
```

Get the user with this format (ISSUER_URL#ACCOUNT_ID)

```bash
kubectl auth whoami
```

Make that into your role binding

```yaml
apiVersion: rbac.authorization.k8s.io/v1
# This cluster role binding allows anyone in the "manager" group to read secrets in any namespace.
kind: ClusterRoleBinding
metadata:
  name: cluser-admin-tuana9a
subjects:
  - kind: User
    name: https://accounts.google.com#105303642619365489614
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
```