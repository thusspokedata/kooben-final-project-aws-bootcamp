# Crear un módulo nuevo para KMS compartido
resource "aws_kms_key" "shared_key" {
  description             = "Shared KMS key for all encryption needs"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "shared_key" {
  name          = "alias/kooben-shared-key"
  target_key_id = aws_kms_key.shared_key.key_id
} 