### setup cluster role for controller
data "aws_iam_policy_document" "eks_cluster_role_trust_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "EKSClusterRole"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_role_policy_attachment_1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

### setup role for the worker
data "aws_iam_policy_document" "eks_node_role_trust_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "eks_auto_scaler" {
  name        = "EKSAutoScaler"
  path        = "/"
  description = "EKS cluster auto scaler"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeLaunchTemplateVersions"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeImages",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name               = "EKSNodeRole"
  assume_role_policy = data.aws_iam_policy_document.eks_node_role_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_role_policy_attachment_4" {
  policy_arn = aws_iam_policy.eks_auto_scaler.arn
  role       = aws_iam_role.eks_node_role.name
}

### init cluster
resource "aws_subnet" "eks_one" {
  vpc_id            = aws_vpc.zero.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name = "eks_one"
  }
}

resource "aws_subnet" "eks_two" {
  vpc_id            = aws_vpc.zero.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "eks_two"
  }
}

resource "aws_subnet" "eks_three" {
  vpc_id            = aws_vpc.zero.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]

  map_public_ip_on_launch = true

  tags = {
    Name = "eks_three"
  }
}

# resource "aws_eks_cluster" "zero" {
#   name     = "zero"
#   role_arn = aws_iam_role.eks_cluster_role.arn
#   version  = "1.28"

#   vpc_config {
#     subnet_ids = [
#       aws_subnet.eks_one.id,
#       aws_subnet.eks_two.id,
#       aws_subnet.eks_three.id,
#     ]
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
#   # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_role_policy_attachment.eks_cluster_role_policy_attachment_1,
#   ]
# }

# resource "aws_eks_addon" "vpc_cni_zero" {
#   cluster_name  = aws_eks_cluster.zero.name
#   addon_name    = "vpc-cni"
#   addon_version = "v1.14.1-eksbuild.1"

#   configuration_values = jsonencode({
#     env = {
#       WARM_IP_TARGET : "3",
#       MINIMUM_IP_TARGET : "3",
#     }
#   })

#   resolve_conflicts_on_update = "PRESERVE"
# }

# resource "aws_eks_addon" "coredns_zero" {
#   cluster_name  = aws_eks_cluster.zero.name
#   addon_name    = "coredns"
#   addon_version = "v1.10.1-eksbuild.2"

#   resolve_conflicts_on_update = "PRESERVE"
# }

# resource "aws_eks_addon" "kube_proxy_zero" {
#   cluster_name  = aws_eks_cluster.zero.name
#   addon_name    = "kube-proxy"
#   addon_version = "v1.28.1-eksbuild.1"

#   resolve_conflicts_on_update = "PRESERVE"
# }

# resource "aws_eks_node_group" "zero" {
#   cluster_name    = aws_eks_cluster.zero.name
#   node_group_name = "zero"
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids = [
#     aws_subnet.eks_one.id,
#     aws_subnet.eks_two.id,
#     aws_subnet.eks_three.id,
#   ]
#   capacity_type = "SPOT"

#   scaling_config {
#     desired_size = 1
#     max_size     = 3
#     min_size     = 0
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.eks_node_role_policy_attachment_1,
#     aws_iam_role_policy_attachment.eks_node_role_policy_attachment_2,
#     aws_iam_role_policy_attachment.eks_node_role_policy_attachment_3,
#     aws_iam_role_policy_attachment.eks_node_role_policy_attachment_4,
#   ]
# }

# output "eks-name" {
#   value = aws_eks_cluster.zero.name
# }

# output "eks-endpoint" {
#   value = aws_eks_cluster.zero.endpoint
# }

# output "eks-version" {
#   value = aws_eks_cluster.zero.version
# }

# output "eks-update-kubeconfig-command" {
#   value = "aws eks update-kubeconfig --name ${aws_eks_cluster.zero.name}"
# }

# resource "local_file" "private_key" {
#   content  = templatefile("cluster-autoscaler-autodiscover.yaml.tftpl", { cluster_name = aws_eks_cluster.zero.name })
#   filename = "cluster-autoscaler-autodiscover.tmp.yaml"
# }
