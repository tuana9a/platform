# https://github.com/google-github-actions/auth?tab=readme-ov-file#workload-identity-federation-through-a-service-account

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = "github"
  description               = "Identity pool for GitHub Action"
}

resource "google_iam_workload_identity_pool_provider" "github_tuana9a" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-tuana9a"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository_owner == 'tuana9a'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}
