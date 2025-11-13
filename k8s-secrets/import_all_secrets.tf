import {
  id = "external-dns/cloudflare-api-token"
  to = module.all_secrets["external-dns"].kubernetes_secret.all_secrets["cloudflare-api-token"]
}

import {
  id = "github-runners/pre-defined-secret"
  to = module.all_secrets["github-runners"].kubernetes_secret.all_secrets["pre-defined-secret"]
}

import {
  id = "jenkins/etcd-defrag"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["etcd-defrag"]
}

import {
  id = "jenkins/backup-kubernetes"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["backup-kubernetes"]
}

import {
  id = "jenkins/backup-kubernetes-env"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["backup-kubernetes-env"]
}

import {
  id = "jenkins/google-login"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["google-login"]
}

import {
  id = "jenkins/vault-backup"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["vault-backup"]
}

import {
  id = "jenkins/vault-unseal-keys"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["vault-unseal-keys"]
}

import {
  id = "jenkins/vault-secret-store-token-renew"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["vault-secret-store-token-renew"]
}

import {
  id = "jenkins/terraform-plan-apply-notify"
  to = module.all_secrets["jenkins"].kubernetes_secret.all_secrets["terraform-plan-apply-notify"]
}
