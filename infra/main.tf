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

module "backend_template" {
  source = "./modules/launch_template"
  
  ec2_specs               = var.ec2_specs
  backend_security_group_id = module.security_groups.backend_security_group_id
  s3_bucket_name          = module.myBucket.s3_bucket_name
  sufix                   = local.sufix
}