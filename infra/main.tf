module "myBucket" {
  source      = "./modules/S3"
  bucket_name = local.s3_sufix
}

module "security_groups" {
  source                      = "./modules/security_groups"
  vpc_id                      = aws_vpc.kooben_vpc.id
  sufix                       = local.sufix
  ingress_ports_list_backend  = var.ingress_ports_list_backend
  ingress_ports_list_frontend = var.ingress_ports_list_frontend
  sg_ingress_cidr             = var.sg_ingress_cidr
}