data "google_iam_workload_identity_pool" "github" {
  provider = google-beta

  workload_identity_pool_id = "github"
}

data "google_iam_workload_identity_pool" "jenkins" {
  provider = google-beta

  workload_identity_pool_id = "jenkins"
}
