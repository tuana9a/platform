resource "aws_iam_role" "terraform_sso_admin" {
  name               = "terraform-sso-admin"
  assume_role_policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Principal": {
        "Federated": "${data.aws_iam_openid_connect_provider.github.arn}"
      },
      "Condition": {
        "StringLike": {
          "token.actions.githubusercontent.com:sub": "repo:tuana9a/platform:*"
        },
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        }
      }
    }
  ]
}
EOT
}

resource "aws_iam_role_policy" "terraform_sso_admin" {
  role   = aws_iam_role.terraform_sso_admin.name
  name   = "terraform-sso-admin"
  policy = data.aws_iam_policy_document.terraform_sso_admin_policy.json
}

data "aws_iam_policy_document" "terraform_sso_admin_policy" {
  # Permission Sets
  statement {
    sid    = "ManagePermissionSets"
    effect = "Allow"
    actions = [
      "sso:CreatePermissionSet",
      "sso:DeletePermissionSet",
      "sso:DescribePermissionSet",
      "sso:ListPermissionSets",
      "sso:UpdatePermissionSet",
      "sso:ProvisionPermissionSet",
      "sso:AttachManagedPolicyToPermissionSet",
      "sso:DetachManagedPolicyFromPermissionSet",
      "sso:ListManagedPoliciesInPermissionSet",
      "sso:PutInlinePolicyToPermissionSet",
      "sso:DeleteInlinePolicyFromPermissionSet",
      "sso:GetInlinePolicyForPermissionSet",
      "sso:AttachCustomerManagedPolicyReferenceToPermissionSet",
      "sso:DetachCustomerManagedPolicyReferenceFromPermissionSet",
      "sso:ListCustomerManagedPolicyReferencesInPermissionSet",
      "sso:PutPermissionsBoundaryToPermissionSet",
      "sso:DeletePermissionsBoundaryFromPermissionSet",
      "sso:GetPermissionsBoundaryForPermissionSet",
      "sso:TagResource",
      "sso:UntagResource",
      "sso:ListTagsForResource",
    ]
    resources = ["*"]
  }

  # Users & Groups (Identity Store)
  statement {
    sid    = "ManageIdentityStoreUsersGroups"
    effect = "Allow"
    actions = [
      "identitystore:CreateUser",
      "identitystore:DeleteUser",
      "identitystore:DescribeUser",
      "identitystore:ListUsers",
      "identitystore:UpdateUser",
      "identitystore:CreateGroup",
      "identitystore:DeleteGroup",
      "identitystore:DescribeGroup",
      "identitystore:ListGroups",
      "identitystore:UpdateGroup",
      "identitystore:CreateGroupMembership",
      "identitystore:DeleteGroupMembership",
      "identitystore:DescribeGroupMembership",
      "identitystore:ListGroupMemberships",
      "identitystore:ListGroupMembershipsForMember",
      "identitystore:IsMemberInGroups",
    ]
    resources = ["*"]
  }

  # Account Assignments
  statement {
    sid    = "ManageAccountAssignments"
    effect = "Allow"
    actions = [
      "sso:CreateAccountAssignment",
      "sso:DeleteAccountAssignment",
      "sso:DescribeAccountAssignmentCreationStatus",
      "sso:DescribeAccountAssignmentDeletionStatus",
      "sso:ListAccountAssignments",
      "sso:ListAccountAssignmentsForPrincipal",
      "sso:ListAccountsForProvisionedPermissionSet",
    ]
    resources = ["*"]
  }

  # Read SSO instance info
  statement {
    sid    = "ReadSSOInstance"
    effect = "Allow"
    actions = [
      "sso:DescribeInstance",
      "sso:ListInstances",
      "sso:GetSharedSsoConfiguration",
    ]
    resources = ["*"]
  }

  # Organizations read (needed to enumerate accounts)
  statement {
    sid    = "ReadOrganizationAccounts"
    effect = "Allow"
    actions = [
      "organizations:DescribeAccount",
      "organizations:ListAccounts",
      "organizations:ListAccountsForParent",
      "organizations:DescribeOrganization",
    ]
    resources = ["*"]
  }

  # IAM read (needed when provisioning permission sets)
  statement {
    sid    = "IAMReadForSSO"
    effect = "Allow"
    actions = [
      "iam:GetSAMLProvider",
      "iam:ListAttachedRolePolicies",
      "iam:GetRole",
    ]
    resources = ["*"]
  }
}
