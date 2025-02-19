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
