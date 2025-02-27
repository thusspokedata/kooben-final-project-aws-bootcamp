kooben_cidr = "10.10.0.0/24" # Total: 256 IPs

# Optimized subnet allocation - each subnet has 64 IPs
public_subnet_cidr    = "10.10.0.0/26"   # 1st public subnet (64 IPs) - AZ c
public_subnet_2_cidr  = "10.10.0.64/26"  # 2nd public subnet (64 IPs) - AZ b
private_subnet_cidr   = "10.10.0.128/26" # 1st private subnet (64 IPs) - AZ a
private_subnet_2_cidr = "10.10.0.192/26" # 2nd private subnet (64 IPs) - AZ b

sg_ingress_cidr = "0.0.0.0/0" # Allow all traffic from the internet

ingress_ports_list_backend  = [22, 80, 3000, 5432]
ingress_ports_list_frontend = [22, 80, 443, 4000]
ingress_ports_list_alb      = [80, 443]
egress_ports_map_alb = {
  "3000" = "backend"
  "4000" = "frontend"
}

tags = {
  "owner"       = "thusspokedata"
  "env"         = "prod"
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
  NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY = "pk_test_..." # Will be overridden in Terraform Cloud
  CLERK_SECRET_KEY                  = "sk_test_..." # Will be overridden in Terraform Cloud
  NEXT_PUBLIC_CLERK_SIGN_IN_URL     = "/sign-in"
  NEXT_PUBLIC_CLERK_SIGN_UP_URL     = "/sign-up"
  NODE_ENV                          = "production"
  PORT                              = "4000"
  NEXT_PUBLIC_API_URL               = "http://backend-alb-..." # Will be updated automatically
}

domain_name = "kooben.cc"

notification_email = "kilo@disroot.org"