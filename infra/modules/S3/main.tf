# Create a Customer-Managed KMS Key for S3 Encryption (tfsec recommendation)
resource "aws_kms_key" "kooben_storage_kms" {
  description             = "KMS key for encrypting the storage bucket"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

# General Storage Bucket (tfsec recommendation)
resource "aws_s3_bucket" "kooben_storage_bucket" {
  bucket = var.bucket_name
}

# Block all public access (tfsec recommendation)
resource "aws_s3_bucket_public_access_block" "kooben_storage_bucket" {
  bucket = aws_s3_bucket.kooben_storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable encryption using AWS KMS Key (tfsec recommendation)
resource "aws_s3_bucket_server_side_encryption_configuration" "kooben_storage_bucket" {
  bucket = aws_s3_bucket.kooben_storage_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.kooben_storage_kms.arn
    }
  }
}

# Enable versioning to track changes & prevent accidental deletions (tfsec recommendation)
resource "aws_s3_bucket_versioning" "kooben_storage_bucket" {
  bucket = aws_s3_bucket.kooben_storage_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable logging inside the same bucket (optional, only if needed for audit logs) (tfsec recommendation)
resource "aws_s3_bucket_logging" "kooben_storage_bucket" {
  bucket        = aws_s3_bucket.kooben_storage_bucket.id
  target_bucket = aws_s3_bucket.kooben_storage_bucket.id
  target_prefix = "logs/"
}

# Upload non-sensitive files to the bucket
resource "aws_s3_object" "docker_compose" {
  bucket = aws_s3_bucket.kooben_storage_bucket.id
  key    = "docker-compose.yml"
  source = "${path.module}/files/docker-compose.yml"
}

# Create a KMS key for Secrets Manager encryption
resource "aws_kms_key" "secrets_encryption_key" {
  description             = "KMS key for Secrets Manager encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Create a secret in AWS Secrets Manager for sensitive environment variables
resource "aws_secretsmanager_secret" "app_env" {
  name       = "app-env-${var.bucket_name}"
  kms_key_id = aws_kms_key.secrets_encryption_key.arn  # Usar nuestra propia clave KMS
}

resource "aws_secretsmanager_secret_version" "app_env" {
  secret_id     = aws_secretsmanager_secret.app_env.id
  secret_string = jsonencode(var.environment_variables)
}