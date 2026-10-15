data "aws_iam_policy_document" "terraform_apply_tuana9a_web_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "${aws_iam_role.github_workflow.arn}",
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/ap-southeast-1/AWSReservedSSO_Admin_c31bf84842b4b2b9",
      ]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "terraform_apply_tuana9a_web_permissions" {
  statement {
    sid    = "ACMPermissions"
    effect = "Allow"
    actions = [
      "acm:DescribeCertificate",
      "acm:RequestCertificate",
      "acm:DeleteCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",
      "acm:AddTagsToCertificate",
      "acm:RemoveTagsFromCertificate",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "CloudFrontPermissions"
    effect = "Allow"
    actions = [
      "cloudfront:CreateDistribution",
      "cloudfront:CreateDistributionWithTags",
      "cloudfront:GetDistribution",
      "cloudfront:UpdateDistribution",
      "cloudfront:DeleteDistribution",
      "cloudfront:TagResource",
      "cloudfront:UntagResource",
      "cloudfront:ListTagsForResource",
      "cloudfront:CreateOriginAccessControl",
      "cloudfront:GetOriginAccessControl",
      "cloudfront:UpdateOriginAccessControl",
      "cloudfront:DeleteOriginAccessControl",
      "cloudfront:ListOriginAccessControls",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "S3BucketPermissions"
    effect = "Allow"
    actions = [
      "s3:CreateBucket",
      "s3:DeleteBucket",
      "s3:GetBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy",
      "s3:GetBucketAcl",
      "s3:GetBucketCORS",
      "s3:GetBucketWebsite",
      "s3:GetBucketVersioning",
      "s3:GetBucketRequestPayment",
      "s3:GetBucketObjectLockConfiguration",
      "s3:GetBucketTagging",
      "s3:PutBucketTagging",
      "s3:GetBucketLogging",
      "s3:GetAccelerateConfiguration",
      "s3:GetReplicationConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetEncryptionConfiguration",
      "s3:ListBucket",
    ]
    resources = ["arn:aws:s3:::tuana9a.com"]
  }
}

resource "aws_iam_policy" "terraform_apply_tuana9a_web" {
  name        = "terraform-apply-tuana9a-web"
  description = "Minimum permissions for Terraform to manage tuana9a.com ACM, CloudFront, and S3"
  policy      = data.aws_iam_policy_document.terraform_apply_tuana9a_web_permissions.json
}

resource "aws_iam_role" "terraform_apply_tuana9a_web" {
  name               = "terraform-apply-tuana9a-web"
  assume_role_policy = data.aws_iam_policy_document.terraform_apply_tuana9a_web_assume_role.json
}

resource "aws_iam_role_policy_attachment" "terraform_apply_tuana9a_web" {
  role       = aws_iam_role.terraform_apply_tuana9a_web.name
  policy_arn = aws_iam_policy.terraform_apply_tuana9a_web.arn
}
