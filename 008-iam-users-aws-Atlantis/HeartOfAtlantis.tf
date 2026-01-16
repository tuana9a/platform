resource "aws_iam_user" "HeartOfAtlantis" {
  name = "HeartOfAtlantis"
}

resource "aws_iam_access_key" "HeartOfAtlantis" {
  user = aws_iam_user.HeartOfAtlantis.name
}

resource "aws_iam_policy" "HeartOfAtlantis" {
  name        = "HeartOfAtlantis"
  description = "HeartOfAtlantis"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["*"]
        Effect   = "Allow"
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "HeartOfAtlantis" {
  user       = aws_iam_user.HeartOfAtlantis.name
  policy_arn = aws_iam_policy.HeartOfAtlantis.arn
}

output "HeartOfAtlantisCreds" {
  value     = <<EOT
aws_access_key_id     = ${aws_iam_access_key.HeartOfAtlantis.id}
aws_secret_access_key = ${aws_iam_access_key.HeartOfAtlantis.secret}
EOT
  sensitive = true
}
