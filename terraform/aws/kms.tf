# KMS Keys for PII Service

# JWT Signing Key
resource "aws_kms_key" "jwt_signing" {
  description              = "PII JWT_SIGNING Key"
  key_usage               = "SIGN_VERIFY"
  customer_master_key_spec = "RSA_4096"
  deletion_window_in_days = 30

  tags = {
    name    = "corsa-pii-jwt-signing"
    KeyType = "JWT_SIGNING"
  }
}

# TOTP Secret Encryption Key
resource "aws_kms_key" "totp_secret_encryption" {
  description              = "PII TOTP_SECRET_ENCRYPTION Key"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days = 30

  tags = {
    name    = "corsa-pii-totp-secret-encryption"
    KeyType = "TOTP_SECRET_ENCRYPTION"
  }
}

# Encryption Key
resource "aws_kms_key" "encryption" {
  description              = "PII ENCRYPTION Key"
  key_usage               = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "RSA_4096"
  deletion_window_in_days = 30

  tags = {
    name    = "corsa-pii-encryption"
    KeyType = "ENCRYPTION"
  }
}

# Invite Challenge Key
resource "aws_kms_key" "invite_challenge" {
  description              = "PII INVITE_CHALLENGE Key"
  key_usage               = "SIGN_VERIFY"
  customer_master_key_spec = "RSA_4096"
  deletion_window_in_days = 30

  tags = {
    name    = "corsa-pii-invite-challenge"
    KeyType = "INVITE_CHALLENGE"
  }
}

# Outputs - ARNs only
output "jwt_signing_key_arn" {
  description = "ARN of the JWT signing KMS key"
  value       = aws_kms_key.jwt_signing.arn
}

output "totp_secret_encryption_key_arn" {
  description = "ARN of the TOTP secret encryption KMS key"
  value       = aws_kms_key.totp_secret_encryption.arn
}

output "encryption_key_arn" {
  description = "ARN of the encryption KMS key"
  value       = aws_kms_key.encryption.arn
}

output "invite_challenge_key_arn" {
  description = "ARN of the invite challenge KMS key"
  value       = aws_kms_key.invite_challenge.arn
}
