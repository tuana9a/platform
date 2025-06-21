resource "kubernetes_manifest" "postgres_env" {
  manifest = yamldecode(file("./manifests/postgres-env.yaml"))
}

resource "kubernetes_manifest" "postgres" {
  manifest   = yamldecode(file("./manifests/postgres.yaml"))
  depends_on = [kubernetes_manifest.postgres_env]
}

resource "kubernetes_manifest" "postgres_backup_env" {
  manifest = yamldecode(file("./manifests/postgres-backup-env.yaml"))
}

resource "kubernetes_manifest" "postgres_backup_cronjob" {
  manifest   = yamldecode(file("./manifests/postgres-backup-cronjob.yaml"))
  depends_on = [ kubernetes_manifest.postgres_backup_env ]
}
