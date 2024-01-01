provider "aws" {
  region                   = "ap-southeast-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}

provider "cloudflare" {
  api_token = local.cloudflare_api_token
}
