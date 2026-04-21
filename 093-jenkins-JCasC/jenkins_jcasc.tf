resource "kubernetes_manifest" "jcasc" {
  for_each = fileset("./manifests", "*")

  manifest = yamldecode(file("./manifests/${each.key}"))
}

resource "kubernetes_config_map" "jcasc_securityrealm" {
  metadata {
    name      = "jcasc-securityrealm"
    namespace = "jenkins"

    labels = {
      "jenkins-jenkins-config" = "true"
    }
  }

  data = {
    "securityrealm.yaml" = templatefile("./templates/jcasc-securityrealm.yaml", {
      google-login-client-id     = local.secrets.google-login.client-id
      google-login-client-secret = local.secrets.google-login.client-secret
    })
  }
}

resource "kubernetes_config_map" "jcasc_credentials" {
  metadata {
    name      = "jcasc-credentials"
    namespace = "jenkins"

    labels = {
      "jenkins-jenkins-config" = "true"
    }
  }

  data = {
    "credentials.yaml" = templatefile("./templates/jcasc-credentials.yaml", {
      VAULT_TOKEN               = local.secrets.VAULT_TOKEN
      TELEGRAM_CHAT_ID          = local.secrets.TELEGRAM_CHAT_ID
      TELEGRAM_BOT_TOKEN        = local.secrets.TELEGRAM_BOT_TOKEN
      vault-unseal-keys-env-b64 = base64encode(local.secrets.vault-unseal-keys-env)
      vault-backup-env-b64      = base64encode(local.secrets.vault-backup-env)
      backup-coder-db-env-b64   = base64encode(local.secrets.backup-coder-db-env)
      k8s-backup-env-b64        = base64encode(local.secrets.k8s-backup-env)
      id_rsa                    = local.secrets.id_rsa
    })
  }
}
