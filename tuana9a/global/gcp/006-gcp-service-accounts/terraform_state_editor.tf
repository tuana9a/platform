resource "google_service_account" "terraform_state_editor" {
  account_id = "terraform-state-editor"
}

resource "google_project_iam_member" "terraform_state_editor_1" {
  project = "tuana9a"
  # https://cloud.google.com/storage/docs/access-control/iam-roles
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.terraform_state_editor.email}"
  condition {
    # https://cloud.google.com/iam/docs/conditions-resource-attributes#resource-name
    title      = "restrict_bucket_terraform_tuana9a"
    expression = "resource.name.startsWith('projects/_/buckets/terraform-tuana9a')"
  }
}

resource "google_service_account_iam_member" "terraform_state_editor_trusted_usage" {
  for_each           = { for i, v in [google_service_account.github_platform_runner.email] : i => v }
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${each.value}"
  service_account_id = google_service_account.terraform_state_editor.name
}
