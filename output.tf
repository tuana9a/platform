output "ubuntu22_ami_arn" {
  value = data.aws_ami.ubuntu22.arn
}

output "amazonlinux2023_ami_arn" {
  value = data.aws_ami.amazonlinux2023.arn
}