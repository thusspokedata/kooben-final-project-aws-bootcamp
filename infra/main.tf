module "networking" {
  source = "./modules/networking"

  vpc_cidr            = var.kooben_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  sufix               = local.sufix
  tags                = var.tags
  random_suffix       = local.random_suffix
}

module "database" {
  source = "./modules/rds"

  sufix                      = local.sufix
  database_name              = "koobenDB"
  database_user              = var.db_username
  database_password          = var.db_password
  instance_class             = var.rds_instance_class
  database_security_group_id = module.security_groups.database_security_group_id
  private_subnet_ids         = module.networking.private_subnet_ids
}

module "myBucket" {
  source      = "./modules/S3"
  bucket_name = local.s3_sufix
  environment_variables = {
    # Database configuration
    DATABASE_URL = "postgresql://${module.database.username}:${var.db_password}@${module.database.endpoint}:${module.database.port}/${module.database.database_name}"
    DB_PASSWORD  = var.db_password
    DB_NAME      = module.database.database_name
    DB_HOST      = module.database.endpoint
    DB_PORT      = module.database.port
    DB_USERNAME  = module.database.username
    
    # Application configuration
    APP_VERSION  = "1.2.0"
    STAGE        = "dev"
    PORT         = "3000"
    HOST_API     = "http://localhost:3000/api"
    
    # Security
    JWT_SECRET   = var.jwt_secret_backend
    
    # Cloudinary configuration
    CLOUDINARY_CLOUD_NAME = "thusspokedata"
    CLOUDINARY_API_KEY    = var.cloudinary_api_key
    CLOUDINARY_API_SECRET = var.cloudinary_api_secret
    CLOUDINARY_URL        = var.cloudinary_url
    
    # Clerk configuration
    CLERK_SECRET_KEY      = var.clerk_secret_key
  }
}

module "security_groups" {
  source                      = "./modules/security_groups"
  vpc_id                      = module.networking.vpc_id
  vpc_cidr                    = var.kooben_cidr
  sufix                       = local.sufix
  ingress_ports_list_backend  = var.ingress_ports_list_backend
  ingress_ports_list_frontend = var.ingress_ports_list_frontend
  sg_ingress_cidr             = var.sg_ingress_cidr
}

module "backend_template" {
  source = "./modules/launch_template"

  ec2_specs                 = var.ec2_specs
  backend_security_group_id = module.security_groups.backend_security_group_id
  s3_bucket_name            = module.myBucket.s3_bucket_name
  sufix                     = local.sufix
}

module "ec2-rds-scheduler" {
  source                      = "github.com/thusspokedata/terraform-aws-ec2-rds-scheduler"
  ec2_start_stop_schedules    = var.ec2_start_stop_schedules
  rds_start_stop_schedules    = var.rds_start_stop_schedules
  asg_start_stop_schedules    = var.asg_start_stop_schedules
  timezone                    = var.timezone
}