# argocd

apply

```bash
terraform init
```

```bash
terraform apply
```

# get argocd admin password

```bash
argocd admin initial-password -n argocd
```

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d ; echo
```

# port forward for argocd access from dev machine
- terraform apply
- web ui access

```bash
kubectl -n argocd port-forward svc/argocd-server --address ${address:-0.0.0.0} ${port:-8443}:443
```
or
```bash
kubectl -n argocd port-forward svc/argocd-server --address ${address:-0.0.0.0} ${port:-8080}:80
```

# add gke cluster

Need to specify other namespace than default `kube-system` because of

```shell
WARNING: This will create a service account `argocd-manager` on the cluster referenced by context `gke_tuana9a_asia-southeast1_zero` with full cluster level privileges. Do you want to continue [y/N]? y
FATA[0005] Failed to create service account "argocd-manager" in namespace "kube-system": serviceaccounts is forbidden: User "tuana9a@gmail.com" cannot create resource "serviceaccounts" in API group "" in the namespace "kube-system": GKE Warden authz [denied by managed-namespaces-limitation]: the namespace "kube-system" is managed and the request's verb "create" is denied
```

There is a fix https://github.com/argoproj/argo-cd/issues/13054 is to specify other namespace

```bash
ctx=gke_tuana9a_asia-southeast1-a_zero
kubectl config use-context $ctx
argocd cluster add $ctx
```

# add new argo project

```yml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: new-project
  namespace: argocd
spec:
  sourceRepos:
    - "*"
  destinations:
    - namespace: "*"
      server: "*"
  clusterResourceWhitelist:
    - group: "*"
      kind: "*"
```

# add digital ocean cluster or any k8s cluster

using service account token as authentication method

```yml
apiVersion: v1
kind: Secret
metadata:
  namespace: argocd
  name: doks-singapore-cluster-creds
  labels:
    argocd.argoproj.io/secret-type: cluster
type: Opaque
stringData:
  name: aca68611-bb11-4a69-a2bb-6029f12a6817.k8s.ondigitalocean.com
  server: https://aca68611-bb11-4a69-a2bb-6029f12a6817.k8s.ondigitalocean.com
  # kubectl -n default create token zeus --duration 30d
  config: |
    {
      "bearerToken": "<kubectl -n default create token zeus --duration=43200m>",
      "tlsClientConfig": {
        "insecure": false,
        "caData": "<base64 cluster ca certificate>"
      }
    }
```

