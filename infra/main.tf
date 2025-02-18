module "myBucket" {
  source      = "./modules/S3"
  bucket_name = local.s3_sufix
}