provider "aws" {
  region                   = local.aws_region
  shared_credentials_files = local.aws_credential_files
  profile                  = local.aws_profile_name
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}
