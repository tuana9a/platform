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
  region                   = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}
