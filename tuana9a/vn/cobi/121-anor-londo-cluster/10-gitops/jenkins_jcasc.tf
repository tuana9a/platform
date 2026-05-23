resource "kubernetes_config_map_v1" "jcasc_general" {
  metadata {
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
    name      = "jcasc-general"

    labels = {
      "jenkins-jenkins-config" = "true"
    }
  }

  data = {
    "jobs.yaml" = file("./jcasc/jcasc-general.yaml")
  }
}

resource "kubernetes_config_map_v1" "jcasc_jobs" {
  metadata {
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name
    name      = "jcasc-jobs"

    labels = {
      "jenkins-jenkins-config" = "true"
    }
  }

  data = {
    "jobs.yaml" = yamlencode({
      jobs = [
        {
          script = file("./jcasc/jobs.generated.groovy")
        }
      ]
    })
  }
}

resource "kubernetes_config_map_v1" "jcasc_securityrealm" {
  metadata {
    name      = "jcasc-securityrealm"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

    labels = {
      "jenkins-jenkins-config" = "true"
    }
  }

  data = {
    "securityrealm.yaml" = templatefile("./jcasc/jcasc-securityrealm.template.yaml", {
      google-login-client-id     = local.secrets.jenkins.google-login.client-id
      google-login-client-secret = local.secrets.jenkins.google-login.client-secret
    })
  }
}

resource "kubernetes_config_map_v1" "jcasc_credentials" {
  metadata {
    name      = "jcasc-credentials"
    namespace = kubernetes_namespace_v1.jenkins.metadata[0].name

    labels = {
      "jenkins-jenkins-config" = "true"
    }
  }

  data = {
    "credentials.yaml" = templatefile("./jcasc/jcasc-credentials.template.yaml", {
      VAULT_TOKEN               = local.secrets.jenkins.VAULT_TOKEN
      TELEGRAM_CHAT_ID          = local.secrets.jenkins.TELEGRAM_CHAT_ID
      TELEGRAM_BOT_TOKEN        = local.secrets.jenkins.TELEGRAM_BOT_TOKEN
      vault-unseal-keys-env-b64 = base64encode(local.secrets.jenkins.vault-unseal-keys-env)
      vault-backup-env-b64      = base64encode(local.secrets.jenkins.vault-backup-env)
      backup-coder-db-env-b64   = base64encode(local.secrets.jenkins.backup-coder-db-env)
      k8s-backup-env-b64        = base64encode(local.secrets.jenkins.k8s-backup-env)
      id_rsa                    = local.secrets.jenkins.id_rsa
    })
  }
}
