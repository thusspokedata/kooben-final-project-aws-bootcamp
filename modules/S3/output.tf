output "bucket_name" {
  value = aws_s3_bucket.kooben_bucket.id
}

output "bucket_arn" {
  value = aws_s3_bucket.kooben_bucket.arn
}