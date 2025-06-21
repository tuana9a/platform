import {
  id = "apiVersion=external-secrets.io/v1beta1,kind=ExternalSecret,namespace=coder,name=coder-env"
  to = kubernetes_manifest.coder_env
}

import {
  id = "apiVersion=apps/v1,kind=StatefulSet,namespace=coder,name=postgres"
  to = kubernetes_manifest.postgres
}

import {
  id = "apiVersion=batch/v1,kind=CronJob,namespace=coder,name=postgres-backup"
  to = kubernetes_manifest.postgres_backup_cronjob
}

import {
  id = "apiVersion=v1,kind=Service,namespace=coder,name=internal"
  to = kubernetes_manifest.internal_service
}
