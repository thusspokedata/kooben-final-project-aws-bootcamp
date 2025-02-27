# Add data sources at the top of the file
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "networking" {
  source = "./modules/networking"

  vpc_cidr              = var.kooben_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  private_subnet_cidr   = var.private_subnet_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  sufix                 = local.sufix
  tags                  = var.tags
  random_suffix         = local.random_suffix
}

module "database" {
  source = "./modules/rds"

  sufix                      = local.sufix
  database_name              = "koobenDB"
  database_user              = var.db_username
  database_password          = var.db_password
  instance_class             = var.rds_instance_class
  database_security_group_id = module.security_groups.database_security_group_id
  private_subnet_ids = [
    module.networking.private_subnet_1_id,
    module.networking.private_subnet_2_id
  ]
}

# Include the KMS module before the modules that will use it
module "kms" {
  source = "./modules/kms"
  
  sufix                 = local.sufix
  tags                  = var.tags
  create_cloudtrail_key = true
  cloudtrail_account_id = data.aws_caller_identity.current.account_id
  cloudtrail_region     = data.aws_region.current.name
}

module "myBucket" {
  source      = "./modules/S3"
  bucket_name = local.s3_sufix
  environment_variables = {
    # Database configuration - without SSL configuration
    DB_PASSWORD = var.db_password
    DB_NAME     = module.database.database_name
    DB_HOST     = trimsuffix(module.database.endpoint, ":5432")
    DB_PORT     = module.database.port
    DB_USERNAME = module.database.username

    # Application configuration
    APP_VERSION = "1.2.0"
    STAGE       = "prod"
    PORT        = "3000"
    HOST_API    = "http://localhost:3000/api"

    # Security
    JWT_SECRET = var.jwt_secret_backend

    # Cloudinary configuration
    CLOUDINARY_CLOUD_NAME = "thusspokedata"
    CLOUDINARY_API_KEY    = var.cloudinary_api_key
    CLOUDINARY_API_SECRET = var.cloudinary_api_secret
    CLOUDINARY_URL        = var.cloudinary_url

    # Clerk configuration
    CLERK_SECRET_KEY = var.clerk_secret_key
  }
  frontend_environment_variables = {
    NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY = var.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
    CLERK_SECRET_KEY                  = var.CLERK_SECRET_KEY
    NEXT_PUBLIC_CLERK_SIGN_IN_URL     = "/sign-in"
    NEXT_PUBLIC_CLERK_SIGN_UP_URL     = "/sign-up"
    NODE_ENV                          = "production"
    PORT                              = "4000"
    NEXT_PUBLIC_API_URL               = "http://api.${var.domain_name}/api"
  }
}

module "security_groups" {
  source                      = "./modules/security_groups"
  vpc_id                      = module.networking.vpc_id
  vpc_cidr                    = var.kooben_cidr
  public_subnet_cidr          = var.public_subnet_cidr
  sufix                       = local.sufix
  ingress_ports_list_backend  = var.ingress_ports_list_backend
  ingress_ports_list_frontend = var.ingress_ports_list_frontend
  ingress_ports_list_alb      = var.ingress_ports_list_alb
  egress_ports_map_alb        = var.egress_ports_map_alb
  sg_ingress_cidr             = var.sg_ingress_cidr
}

module "iam" {
  source         = "./modules/iam"
  sufix          = local.sufix
  s3_bucket_name = module.myBucket.s3_bucket_name
  tags           = var.tags
  region         = data.aws_region.current.name
  account_id     = data.aws_caller_identity.current.account_id
}

module "backend_template" {
  source = "./modules/backend/launch_template"

  ec2_specs                 = var.ec2_specs
  backend_security_group_id = module.security_groups.backend_security_group_id
  s3_bucket_name            = module.myBucket.s3_bucket_name
  sufix                     = local.sufix
  instance_profile_name     = module.iam.ec2_instance_profile_name
  public_subnet_id          = module.networking.public_subnet_id
}

module "ec2-rds-scheduler" {
  source                   = "github.com/thusspokedata/terraform-aws-ec2-rds-scheduler"
  aws_region               = data.aws_region.current.name
  ec2_start_stop_schedules = var.ec2_start_stop_schedules
  rds_start_stop_schedules = var.rds_start_stop_schedules
  asg_start_stop_schedules = var.asg_start_stop_schedules
  timezone                 = var.timezone
}

module "alb" {
  source = "./modules/alb"

  sufix                 = local.sufix
  vpc_id                = module.networking.vpc_id
  alb_security_group_id = module.security_groups.alb_security_group_id
  public_subnet_ids = [
    module.networking.public_subnet_id,
    module.networking.public_subnet_2_id
  ]
  domain_name            = var.domain_name
  create_acm_certificate = true
  validate_certificate   = false
}

module "sns" {
  source             = "./modules/sns"
  sufix              = local.sufix
  notification_email = var.notification_email
  tags               = var.tags
}

module "asg" {
  source = "./modules/backend/asg"

  sufix            = local.sufix
  target_group_arn = module.alb.backend_target_group_arn
  public_subnet_ids = [
    module.networking.public_subnet_id,
    module.networking.public_subnet_2_id
  ]
  launch_template_id = module.backend_template.launch_template_id
  sns_topic_arn      = module.sns.topic_arn
}

module "frontend_template" {
  source = "./modules/frontend/launch_template"

  ec2_specs                  = var.ec2_specs
  frontend_security_group_id = module.security_groups.frontend_security_group_id
  s3_bucket_name             = module.myBucket.s3_bucket_name
  sufix                      = local.sufix
  instance_profile_name      = module.iam.ec2_instance_profile_name
  docker_compose_version     = "2.20.2"
}

module "frontend_asg" {
  source = "./modules/frontend/asg"

  sufix            = local.sufix
  target_group_arn = module.alb.frontend_target_group_arn
  public_subnet_ids = [
    module.networking.public_subnet_id,
    module.networking.public_subnet_2_id
  ]
  launch_template_id = module.frontend_template.launch_template_id
  sns_topic_arn      = module.sns.topic_arn
}

module "route53" {
  source = "./modules/route53"

  sufix                 = local.sufix
  domain_name           = var.domain_name
  frontend_alb_dns_name = module.alb.alb_dns_name
  frontend_alb_zone_id  = module.alb.alb_zone_id
  backend_alb_dns_name  = module.alb.alb_dns_name
  backend_alb_zone_id   = module.alb.alb_zone_id
}

module "cloudtrail" {
  source = "./modules/cloudtrail"

  sufix                      = local.sufix
  enable_log_file_validation = true
  is_multi_region_trail      = true
  cloudtrail_retention_days  = 90
  tags                       = var.tags
  
  # Use the existing S3 bucket instead of creating a new one
  existing_s3_bucket_name = module.myBucket.s3_bucket_name
  existing_s3_bucket_id   = module.myBucket.s3_bucket_id
  existing_s3_bucket_arn  = module.myBucket.s3_bucket_arn
  
  # Use the IAM role from the IAM module
  cloudtrail_cloudwatch_role_arn = module.iam.cloudtrail_cloudwatch_role_arn
  cloudtrail_cloudwatch_role_id  = module.iam.cloudtrail_cloudwatch_role_id
  
  # Use the KMS key from the KMS module
  kms_key_id = module.kms.cloudtrail_key_arn
  create_internal_kms_key = false
}