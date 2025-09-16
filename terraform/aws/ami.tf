data "aws_ami" "corsa_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["corsa-pii-ubuntu*"]
  }

  owners = [var.ami_owner]
}
