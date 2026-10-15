resource "google_service_account" "github_platform_runner" {
  account_id = "github-platform-runner"
}

resource "google_service_account_iam_binding" "github_platform_runner_claims" {
  service_account_id = google_service_account.github_platform_runner.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    # See https://github.com/google-github-actions/auth?tab=readme-ov-file#workload-identity-federation-through-a-service-account
    "principalSet://iam.googleapis.com/projects/${data.google_project.current.number}/locations/global/workloadIdentityPools/${data.google_iam_workload_identity_pool.github.workload_identity_pool_id}/attribute.repository/tuana9a/platform",
  ]
}
