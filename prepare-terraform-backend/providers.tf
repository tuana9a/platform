terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region                   = local.aws_region
  shared_credentials_files = local.aws_credential_files
  profile                  = local.aws_profile_name
}
