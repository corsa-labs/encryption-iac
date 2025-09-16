locals {
  kms_keys = {
    jwt_signing           = aws_kms_key.jwt_signing.id
    totp_secret_encryption = aws_kms_key.totp_secret_encryption.id
    encryption           = aws_kms_key.encryption.id
    invite_challenge     = aws_kms_key.invite_challenge.id
  }
}


# Get current AWS account ID
data "aws_caller_identity" "current" {}

# IAM Role for EC2 instance
resource "aws_iam_role" "corsa_pii_role" {
  name = "corsa-pii"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach SSM managed policy
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.corsa_pii_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# EC2 Instance Profile
resource "aws_iam_instance_profile" "corsa_pii_profile" {
  name = "corsa-pii"
  role = aws_iam_role.corsa_pii_role.name
}


# KMS Key Policies for all keys using for_each
resource "aws_kms_key_policy" "kms_policies" {
  for_each = local.kms_keys

  key_id = each.value

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            aws_iam_role.corsa_pii_role.arn
          ]
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
            aws_iam_role.corsa_pii_role.arn
          ]
        }
        Action   = "kms:GetKeyPolicy"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.corsa_pii_role.arn
        }
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyPair",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:GenerateDataKeyPairWithoutPlaintext",
          "kms:GenerateRandom",
          "kms:GetKeyPolicy",
          "kms:Sign",
          "kms:Verify",
          "kms:GetPublicKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}

# Output the instance profile ARN
output "instance_profile_arn" {
  description = "ARN of the EC2 instance profile"
  value       = aws_iam_instance_profile.corsa_pii_profile.arn
}

output "instance_role_arn" {
  description = "ARN of the IAM role"
  value       = aws_iam_role.corsa_pii_role.arn
}
