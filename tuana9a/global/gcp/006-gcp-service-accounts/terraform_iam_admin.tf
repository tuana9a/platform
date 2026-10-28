resource "google_service_account" "terraform_iam_admin" {
  account_id = "terraform-iam-admin"
}

resource "google_project_iam_member" "terraform_iam_admin" {
  project = "tuana9a"
  # https://cloud.google.com/storage/docs/access-control/iam-roles

  for_each = { for i, v in [
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.workloadIdentityPoolAdmin",
  ] : i => v }

  role   = each.value
  member = "serviceAccount:${google_service_account.terraform_iam_admin.email}"
}

resource "google_service_account_iam_member" "terraform_iam_admin_user" {
  for_each = { for i, v in [
    "serviceAccount:${google_service_account.github_platform_runner.email}",
    "user:tuana9a@gmail.com"
  ] : i => v }
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = each.value
  service_account_id = google_service_account.terraform_iam_admin.name
}
