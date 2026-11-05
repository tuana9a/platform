resource "aws_key_pair" "key_pair_1" {
  key_name   = "key_pair_1"
  public_key = file("~/.ssh/id_ed25519.pub")
}