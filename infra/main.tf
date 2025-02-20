module "database" {
  source = "./modules/rds"
  
  sufix                     = local.sufix
  database_name            = "kooben"
  database_user            = var.db_username
  database_password        = var.db_password
  instance_class           = var.rds_instance_class
  database_security_group_id = module.security_groups.database_security_group_id
  private_subnet_ids       = [aws_subnet.kooben_private_subnet.id]
}

module "myBucket" {
  source      = "./modules/S3"
  bucket_name = local.s3_sufix
  environment_variables = {
    DATABASE_URL = "postgresql://${module.database.username}:${var.db_password}@${module.database.endpoint}:${module.database.port}/${module.database.database_name}"
  }
}

module "security_groups" {
  source                      = "./modules/security_groups"
  vpc_id                      = aws_vpc.kooben_vpc.id
  vpc_cidr                    = var.kooben_cidr
  sufix                       = local.sufix
  ingress_ports_list_backend  = var.ingress_ports_list_backend
  ingress_ports_list_frontend = var.ingress_ports_list_frontend
  sg_ingress_cidr             = var.sg_ingress_cidr
}

module "backend_template" {
  source = "./modules/launch_template"
  
  ec2_specs                = var.ec2_specs
  backend_security_group_id = module.security_groups.backend_security_group_id
  s3_bucket_name          = module.myBucket.s3_bucket_name
  sufix                   = local.sufix
}