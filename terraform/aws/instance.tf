
resource "aws_security_group" "corsa_pii" {
  name        = "corsa-pii"
  description = "Security group for corsa-pii EC2 instance"
  vpc_id      =  var.vpc_id

  # Inbound rules
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Application port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules
  egress {
    description = "All outbound TCP traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "corsa-pii"
  }
}

data "template_file" "ebs_mount_script" {
  template = file("${path.module}/userdata-mount-ebs.tftpl")
  vars = {
    ebs_volume_id = aws_ebs_volume.corsa_pii_volume.id
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.tftpl")
  vars = {
    mount_script = data.template_file.ebs_mount_script.rendered
    corsa_jwks_issuer = var.corsa_jwks
    auth0_audience = var.auth0_audience
    encryption_arn = aws_kms_key.encryption.arn
    invite_challenge_arn = aws_kms_key.invite_challenge.arn
    jwt_signing_arn = aws_kms_key.jwt_signing.arn
    totp_secret_encryption_arn = aws_kms_key.totp_secret_encryption.arn
  }
}

resource "aws_instance" "corsa_pii" {
  ami           = data.aws_ami.corsa_ami.id
  instance_type = "t3.micro"
  user_data     = data.template_file.user_data.rendered
  iam_instance_profile   = aws_iam_instance_profile.corsa_pii_profile.name
  subnet_id = aws_subnet.corsa_pii.id
  vpc_security_group_ids = [aws_security_group.corsa_pii.id]
  key_name = var.key_name
  tags = {
    Name = "corsa-pii"
  }
}

resource "aws_volume_attachment" "corsa_pii_volume_attachment" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.corsa_pii_volume.id
  instance_id = aws_instance.corsa_pii.id
}
