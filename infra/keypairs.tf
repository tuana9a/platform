resource "aws_key_pair" "dev" {
  key_name   = var.aws_key_pair_name
  public_key = file(var.aws_key_pair_public_key_file)
}