# https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy

resource "aws_iam_role" "terraform_ecr_admin" {
  name               = "terraform-ecr-admin"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "${aws_iam_role.github_workflow.arn}",
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-reserved/sso.amazonaws.com/ap-southeast-1/AWSReservedSSO_Admin_c31bf84842b4b2b9"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOT
}

resource "aws_iam_role_policy" "terraform_ecr_admin" {
  role   = aws_iam_role.terraform_ecr_admin.name
  name   = "terraform-ecr-admin"
  policy = data.aws_iam_policy_document.terraform_ecr_admin_policy.json
}

data "aws_iam_policy_document" "terraform_ecr_admin_policy" {
  statement {
    effect = "Allow"
    actions = [
      // repo
      "ecr:CreateRepository",
      "ecr:DescribeRepositories",
      "ecr:ListRepositories",
      "ecr:DeleteRepository",
      // registry
      "ecr:DescribeRegistry",
      "ecr:PutRegistryPolicy",
      "ecr:GetRegistryPolicy",
      "ecr:DeleteRegistryPolicy",
      // policy
      "ecr:SetRepositoryPolicy",
      "ecr:GetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
      // life cycle
      "ecr:PutLifecyclePolicy",
      "ecr:DeleteLifecyclePolicy",
      "ecr:GetLifecyclePolicy",
      "ecr:GetLifecyclePolicyPreview",
      // tag
      "ecr:TagResource",
      "ecr:UntagResource",
      "ecr:ListTagsForResource",
      // replication
      "ecr:PutReplicationConfiguration",
      "ecr:DescribeReplicationConfigurations",
      // other
      "ecr:GetAuthorizationToken",
      "ecr:StartImageScan",
      "ecr:DescribeImageScanFindings"
    ]
    resources = ["*"]
  }
}
