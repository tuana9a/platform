terraform {
  required_version = ">= 1.3"

  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 17.0"
    }
  }
}
