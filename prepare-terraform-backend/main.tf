locals {
  name = "tuana9a-platform"
}

resource "aws_s3_bucket" "platform" {
  bucket        = local.name
  force_destroy = false
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = local.name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}

output "bucket-name" {
  value = aws_s3_bucket.platform.bucket
}
