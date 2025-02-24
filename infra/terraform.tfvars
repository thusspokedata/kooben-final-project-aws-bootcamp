kooben_cidr = "10.10.0.0/16"

public_subnet_cidr  = "10.10.0.0/24"
private_subnet_cidr = "10.10.1.0/24"

sg_ingress_cidr = "0.0.0.0/0" # Allow all traffic from the internet

ingress_ports_list_backend  = [22, 80, 3000, 5432]
ingress_ports_list_frontend = [80, 443, 22, 4000]

tags = {
  "owner"       = "thusspokedata"
  "env"         = "dev"
  "cloud"       = "aws"
  "IAC"         = "terraform-cloud"
  "IAC_version" = "1.10.5"
  "project"     = "kooben"
  "region"      = "frankfurt"
}

ec2_specs = {
  "instance_type" = "t2.micro"
  "ami"           = "ami-07eef52105e8a2059"
}

rds_instance_class = "db.t4g.micro"

ec2_start_stop_schedules = {
  "schedule_dev" = {
    "cron_stop"  = "cron(00 23 ? * * *)" # 23:00 Berlin time
    "cron_start" = "cron(00 06 ? * * *)" # 06:00 Berlin time
    "tag_key"    = "env"
    "tag_value"  = "dev"
  }

}

rds_start_stop_schedules = {
  "rds_schedule_dev" = {
    "cron_stop"  = "cron(15 23 ? * * *)" # 23:15 Berlin time (15 min after EC2)
    "cron_start" = "cron(45 05 ? * * *)" # 05:45 Berlin time (15 min before EC2)
    "tag_key"    = "env"
    "tag_value"  = "dev"
  }
}

timezone = "Europe/Berlin"

frontend_environment_variables = {
  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY = "pk_test_..."  # Will be overridden in Terraform Cloud
  CLERK_SECRET_KEY                  = "sk_test_..."  # Will be overridden in Terraform Cloud
  NEXT_PUBLIC_CLERK_SIGN_IN_URL     = "/sign-in"
  NEXT_PUBLIC_CLERK_SIGN_UP_URL     = "/sign-up"
  NODE_ENV                          = "production"
  PORT                              = "4000"
  NEXT_PUBLIC_API_URL               = "http://backend-alb-..."  # Will be updated automatically
}