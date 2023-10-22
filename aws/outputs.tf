output "ec2_zion_public_ip" {
  value = aws_instance.zion.public_ip
}

output "eip_zion_public_ip" {
  value = aws_eip.zion.public_ip
}
