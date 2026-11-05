resource "aws_iam_role" "SSMInstanceProfile" {
  name = "SSMInstanceProfile"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
  }
}

resource "aws_iam_role_policy_attachment" "SSMInstanceProfile" {
  role       = aws_iam_role.SSMInstanceProfile.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "SSMInstanceProfile" {
  name = "SSMInstanceProfile"
  role = aws_iam_role.SSMInstanceProfile.name
}
