resource "google_iam_workload_identity_pool" "jenkins" {
  workload_identity_pool_id = "jenkins"
  description               = "Identity pool for jenkins.tuana9a.com"
}

resource "google_iam_workload_identity_pool_provider" "jenkins_tuana9a_com" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.jenkins.workload_identity_pool_id
  workload_identity_pool_provider_id = "jenkins-tuana9a-com"

  attribute_mapping = {
    "google.subject" = "assertion.sub"
  }

  oidc {
    issuer_uri = "https://jenkins.tuana9a.com/oidc"
  }
}
