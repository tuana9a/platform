resource "aws_ecr_repository" "registry_k8s_io" {
  name = "registry.k8s.io"

  image_tag_mutability = true

  image_scanning_configuration {
    scan_on_push = false
  }
}

data "aws_iam_policy_document" "registry_k8s_io" {
  statement {
    sid    = "allow-pull"
    effect = "Allow"
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
    ]
  }

  statement {
    sid    = "allow-push"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }

    actions = [
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "registry_k8s_io" {
  repository = aws_ecr_repository.registry_k8s_io.name
  policy     = data.aws_iam_policy_document.exregistry_k8s_ioample.json
}
