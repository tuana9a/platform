resource "kubernetes_manifest" "clustersecrestorestore_vault_tuana9a_com" {
  manifest = yamldecode(<<EOF
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-tuana9a-com
spec:
  provider:
    vault:
      server: "https://vault.tuana9a.com"
      path: "kv"
      # Version is the Vault KV secret engine version.
      # This can be either "v1" or "v2", defaults to "v2"
      version: "v1"
      auth:
        jwt:
          # The name of the JWT role configured in Vault
          role: "vault-secret-operator"
          path: "in-cluster"
          kubernetesServiceAccountToken:
            serviceAccountRef:
              namespace: "vault"
              name: "vault-secret-operator"
              audiences:
                - "https://192.168.56.21:6443"
                - "https://kubernetes.default.svc.cluster.local"
            expirationSeconds: 600
EOF
  )
}

resource "kubernetes_manifest" "clustersecrestorestore_vault_tuana9a_com_v2" {
  manifest = yamldecode(<<EOF
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: vault-tuana9a-com-v2
spec:
  provider:
    vault:
      server: "https://vault.tuana9a.com"
      path: "kvv2"
      # Version is the Vault KV secret engine version.
      # This can be either "v1" or "v2", defaults to "v2"
      version: "v2"
      auth:
        jwt:
          # The name of the JWT role configured in Vault
          role: "vault-secret-operator"
          path: "in-cluster"
          kubernetesServiceAccountToken:
            serviceAccountRef:
              namespace: "vault"
              name: "vault-secret-operator"
              audiences:
                - "https://192.168.56.21:6443"
                - "https://kubernetes.default.svc.cluster.local"
            expirationSeconds: 600
EOF
  )
}
