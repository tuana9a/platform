# platform

tuana9a's platform

- `ansible`: configuration as code
- `terraform`: infrastructure as code
- `github`: code, `github-workflow`: cicd
- `Jenkins`: cicd
- `argocd`: cd
- `aws`
- `gcp`: terraform state
- `proxmox`
- `cloudflare`: dns, cdn, web, r2
- `haproxy`: lb
- `nginx`: ingress, lb, web
- `vault`: secret manager
- `knative`: serverless
- `k8s`: infra
- `flannel`: k8s cni
- `metallb`: k8s lb
- `vm`: stuffs
- `cert-manager`: manage ssl
- `grafana`, `prometheus`, `loki`: monitoring
- `coder`: vscode server
- `digitalcoean`: not yet
- `docker`

# graph

```mermaid
graph TB
    root --> 020-proxmox-cloudimg[proxmox-cloudimg]
    root --> 040-proxmox-sdn-neo[proxmox-sdn]

    020-proxmox-cloudimg --> 068[k8s-cobi-tuana9a]
    040-proxmox-sdn-neo --> 068

    068 --> 080-flannel((flannel))

    080-flannel --> 085-spegel[spegel]
    080-flannel --> 190-metallb[metallb]
    080-flannel --> 090-argocd((argocd))
    080-flannel --> 200-ingress-nginx[ingress-nginx]
    080-flannel --> 200-cert-manager[cert-manager]
    080-flannel --> 165-proxmox-csi[proxmox-csi]
    080-flannel --> 197-external-secrets[external-secrets]

    165-proxmox-csi --> 092-jenkins((jenkins))
    200-ingress-nginx --> 092-jenkins
    200-cert-manager --> 092-jenkins
    200-ingress-nginx --> 195-vault((vault))
    200-cert-manager --> 195-vault
    165-proxmox-csi --> 195-vault

    165-proxmox-csi --> 300-loki[loki]
    165-proxmox-csi --> 300-prometheus[prometheus]

    090-argocd --> 210-knative[knative]
    090-argocd --> 093-jenkins-jcasc[jcasc]
    090-argocd --> 555-pool[pool]

    092-jenkins --> 093-jenkins-jcasc

    555-pool -- pgpool --> 502-coder[coder]
    195-vault --> 502-coder
```
