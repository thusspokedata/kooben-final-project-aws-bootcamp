# **Kooben AWS Infrastructure - Terraform Deployment**

## **📌 Overview**
This repository contains the infrastructure configuration for the **Kooben** project using **Terraform**. It is designed to deploy an AWS-based architecture, including a **VPC, subnets, security groups, and an S3 bucket**.

---

## **🛠 Project Structure**
```
.
├── infra/                      # Terraform infrastructure files
│   ├── modules/                # Terraform modules
│   │   ├── kms/                # KMS module for encryption
│   │   │   ├── main.tf
│   │   ├── launch_template/     # EC2 Launch Template module
│   │   │   ├── main.tf
│   │   │   ├── user_data.sh     # Script for EC2 user data
│   │   │   ├── variables.tf
│   │   ├── networking/          # Networking-related modules
│   │   │   ├── modules/         # Submodules inside networking
│   │   │   │   ├── flow_logs/   # VPC Flow Logs module
│   │   │   │   │   ├── main.tf
│   │   │   │   │   ├── outputs.tf
│   │   │   │   │   ├── variables.tf
│   │   │   │   ├── routing/     # Routing-related configurations
│   │   │   │   │   ├── main.tf
│   │   │   │   │   ├── variables.tf
│   │   │   │   ├── vpc/         # VPC module
│   │   │   │   │   ├── main.tf
│   │   │   │   │   ├── outputs.tf
│   │   │   │   │   ├── variables.tf
│   │   ├── rds/                 # RDS database module
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── variables.tf
│   │   ├── S3/                  # S3 Bucket module
│   │   ├── files/               # Files module, contains extra configurations
│   │   │   ├── docker-compose.yml
│   │   │   ├── main.tf
│   │   │   ├── output.tf
│   │   │   ├── variables.tf
│   │   ├── security_groups/      # Security Groups module
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   ├── variables.tf
│   ├── locals.tf                # Local variables for Terraform
│   ├── main.tf                   # Main entry point for Terraform
│   ├── outputs.tf                # Terraform output definitions
│   ├── providers.tf              # Terraform provider configurations
│   ├── terraform.tfvars          # Environment-specific variables (not committed)
│   ├── variables.tf              # Variable definitions
├── .gitignore                    # Files ignored by Git
├── README.md                     # Project documentation
├── documentation/                 # Project documentation folder
│   ├── s3.md                     # Documentation for S3 configuration
│   ├── COMMANDS.md                # List of useful Terraform commands
│   ├── tools-i-used/              # Documentation for tools used
│   │   ├── infracost.md           # Infracost documentation
│   │   ├── tfenv.md               # tfenv documentation
│   │   ├── tfsec.md               # tfsec documentation
│   │   ├── tflint.md              # tflint documentation
```

---

## **🚀 Getting Started**
### **1️⃣ Prerequisites**
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- [tfenv](https://github.com/tfutils/tfenv) (for managing Terraform versions) ([Documentation](documentacion/tools-i-used/tfenv.md))
- [TFLint](https://github.com/terraform-linters/tflint) (for linting) ([Documentation](documentacion/tools-i-used/tflint.md))
- [Infracost](https://www.infracost.io/) (for cost estimation) ([Documentation](documentacion/tools-i-used/infracost.md))
- [tfsec](https://aquasecurity.github.io/tfsec/) (for security analysis) ([Documentation](documentacion/tools-i-used/tfsec.md))

### **2️⃣ Setting Up Terraform**
```bash
# Install and use the correct Terraform version
tfenv install 1.10.5  
tfenv use 1.10.5      
terraform init        # Initialize Terraform
terraform validate    # Validate Terraform configuration
terraform plan        # Preview changes
terraform apply       # Apply changes to AWS
```

### **3️⃣ Running Security and Cost Analysis**
```bash
infracost breakdown --path ./infra  # Cost estimation
tflint                              # Run Terraform Linter to check for best practices
tfsec                               # Perform security analysis on Terraform configuration
```

---

## **🔗 Useful Links**
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- [Infracost Documentation](documentacion/tools-i-used/infracost.md)
- [TFLint Documentation](documentacion/tools-i-used/tflint.md)
- [tfenv Documentation](documentacion/tools-i-used/tfenv.md)
- [tfsec Documentation](documentacion/tools-i-used/tfsec.md)
- [S3 Configuration Documentation](documentacion/s3.md)

## **📌 Next Steps**
- Deploy new services (e.g., EC2-backend, EC2-frontend, RDS)
- Implement monitoring (CloudWatch, CloudTrail)
- Automate CI/CD for Terraform deployments
- Integrate Route 53 for domain management
- Create Auto Scaling Group for dynamic scaling
- Configure Launch Templates for backend and frontend instances
- Deploy an Application Load Balancer (ALB)
