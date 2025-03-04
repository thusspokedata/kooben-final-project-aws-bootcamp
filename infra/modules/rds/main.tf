# Create a KMS key for RDS encryption
resource "aws_kms_key" "rds_encryption_key" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Create the RDS instance
resource "aws_db_instance" "kooben_db" {
  identifier        = "kooben-db-${var.sufix}"
  engine            = "postgres"
  engine_version    = "16.3"
  instance_class    = var.instance_class
  allocated_storage = 20

  db_name  = var.database_name
  username = var.database_user
  password = var.database_password

  vpc_security_group_ids = [var.database_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.kooben.name

  # Enhanced security (tfsec recommendations)
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds_encryption_key.arn
  #tfsec:ignore:aws-rds-enable-deletion-protection
  deletion_protection                 = false # it it just false for learning porpuses set to true for production
  iam_database_authentication_enabled = true
  skip_final_snapshot                 = true

  # Performance monitoring (tfsec recommendation)
  performance_insights_enabled          = true
  performance_insights_kms_key_id       = aws_kms_key.rds_encryption_key.arn
  performance_insights_retention_period = 7

  # Backup configuration
  backup_retention_period = 7
  backup_window           = "21:00-22:00"
  maintenance_window      = "Mon:06:00-Mon:07:00"

  # Network configuration
  multi_az            = false # Set to true for production
  publicly_accessible = false

  availability_zone = "eu-central-1a"

  tags = {
    Name = "kooben-db-${var.sufix}"
  }
}

# Create DB subnet group
resource "aws_db_subnet_group" "kooben" {
  name       = "kooben-db-subnet-group-${var.sufix}"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "kooben-db-subnet-group-${var.sufix}"
  }
} 