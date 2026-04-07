resource "google_storage_bucket" "terraform_tuana9a" {
  name     = "terraform-tuana9a"
  location = "ASIA-SOUTHEAST1"

  force_destroy = false

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      # Delete the version if there are 10 newer versions
      num_newer_versions = 10

      # Recommended: apply only to archived (non-current) versions
      with_state = "ARCHIVED"
    }
    action {
      type = "Delete"
    }
  }
}
