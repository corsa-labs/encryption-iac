resource "aws_ebs_volume" "corsa_pii_volume" {
  availability_zone = aws_subnet.corsa_pii.availability_zone
  size              = 1
  type              = "gp3"

  tags = {
    Name = "corsa-pii-volume"
  }
}
