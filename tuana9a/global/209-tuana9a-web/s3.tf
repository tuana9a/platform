resource "aws_s3_bucket" "tuana9a_com" {
  bucket = "tuana9a.com"
}

data "aws_iam_policy_document" "tuana9a_com_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.tuana9a_com.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.tuana9a_com.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "tuana9a_com" {
  bucket = aws_s3_bucket.tuana9a_com.bucket
  policy = data.aws_iam_policy_document.tuana9a_com_bucket_policy.json
}
