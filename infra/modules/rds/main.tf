# Create a KMS key for RDS encryption
resource "aws_kms_key" "rds_encryption_key" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Create the RDS instance
resource "aws_db_instance" "kooben_db" {
  identifier        = "kooben-db-${var.sufix}"
  engine           = "postgres"
  engine_version   = "14"
  instance_class   = var.instance_class
  allocated_storage = 20

  db_name  = var.database_name
  username = var.database_user
  password = var.database_password

  vpc_security_group_ids = [var.database_security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.kooben.name

  # Enhanced security
  storage_encrypted   = true
  kms_key_id         = aws_kms_key.rds_encryption_key.arn
  skip_final_snapshot = false
  
  # Backup configuration
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  # Network configuration
  multi_az               = false  # Set to true for production
  publicly_accessible    = false

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