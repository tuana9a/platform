resource "google_service_account" "terraform_artifact_admin" {
  account_id = "terraform-artifact-admin"
}

resource "google_project_iam_member" "terraform_artifact_admin_1" {
  project = var.gcp_project_name
  # https://cloud.google.com/storage/docs/access-control/iam-roles
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.terraform_artifact_admin.email}"
  condition {
    # https://cloud.google.com/iam/docs/conditions-resource-attributes#resource-name
    title      = "restrict_bucket_terraform_tuana9a"
    expression = "resource.name.startsWith('projects/_/buckets/terraform-tuana9a')"
  }
}

resource "google_project_iam_member" "terraform_artifact_admin_2" {
  project = var.gcp_project_name
  # https://cloud.google.com/storage/docs/access-control/iam-roles
  role   = "roles/artifactregistry.admin"
  member = "serviceAccount:${google_service_account.terraform_artifact_admin.email}"
}

resource "google_service_account_iam_binding" "terraform_artifact_admin_claims" {
  service_account_id = google_service_account.terraform_artifact_admin.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    # See https://github.com/google-github-actions/auth?tab=readme-ov-file#workload-identity-federation-through-a-service-account
    "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${data.google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/tuana9a/platform",
  ]
}
