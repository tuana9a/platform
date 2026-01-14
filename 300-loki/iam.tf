resource "aws_iam_user" "loki_k8s_cobi_tuana9a" {
  name = "loki-k8s-cobi-tuana9a"
}

resource "aws_iam_access_key" "loki_k8s_cobi_tuana9a" {
  user = aws_iam_user.loki_k8s_cobi_tuana9a.name
}

resource "aws_iam_policy" "loki_k8s_cobi_tuana9a_policy" {
  name        = "LokiK8sCobiTuana9a"
  description = "Loki's things"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.loki_chunks_k8s_cobi_tuana9a.arn}/*",
          "${aws_s3_bucket.loki_ruler_k8s_cobi_tuana9a.arn}/*",
        ]
      },
      {
        Action = ["s3:ListBucket"]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.loki_chunks_k8s_cobi_tuana9a.arn}",
          "${aws_s3_bucket.loki_ruler_k8s_cobi_tuana9a.arn}",
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "loki_k8s_cobi_tuana9a" {
  user       = aws_iam_user.loki_k8s_cobi_tuana9a.name
  policy_arn = aws_iam_policy.loki_k8s_cobi_tuana9a_policy.arn
}
