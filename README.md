# **Kooben AWS Infrastructure - Terraform Deployment**

## **📌 Overview**
This repository contains the infrastructure configuration for the **Kooben** project using **Terraform**. It is designed to deploy an AWS-based architecture, including a VPC, subnets, security groups, and an S3 bucket.

## **🛠 Project Structure**
```
.
├── infra/                 # Terraform infrastructure files
│   ├── vpc.tf             # VPC and Subnets
│   ├── internet_gateway.tf # Internet Gateway & NAT Gateway
│   ├── route_tables.tf     # Route tables and associations
│   ├── security_groups.tf  # Security groups definitions
│   ├── providers.tf        # Terraform provider configurations
│   ├── variables.tf        # Variable definitions
│   ├── terraform.tfvars    # Environment-specific variables (not committed)
├── modules/               # Terraform modules
│   ├── S3/                # S3 Bucket module
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── variables.tf
├── .gitignore             # Files ignored by Git
├── COMMANDS.md            # List of useful Terraform commands
├── README.md              # Project documentation
```

## **🚀 Getting Started**
### **1️⃣ Prerequisites**
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://aws.amazon.com/cli/)
- [tfenv](https://github.com/tfutils/tfenv) (for managing Terraform versions)
- [TFLint](https://github.com/terraform-linters/tflint) (for linting)
- [Infracost](https://www.infracost.io/) (for cost estimation)

### **2️⃣ Setting Up Terraform**
```bash
tfenv install 1.10.5  # Install required Terraform version
tfenv use 1.10.5      # Set Terraform to use this version
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

### **4️⃣ Managing AWS Infrastructure**
#### **Check Available Terraform Versions**
```bash
tfenv list-remote   # List available Terraform versions
tfenv list          # List installed Terraform versions
```

#### **Run Terraform Commands**
```bash
terraform fmt       # Format Terraform files
terraform validate  # Validate configuration
terraform plan      # Show execution plan
terraform apply     # Deploy infrastructure
terraform destroy   # Destroy infrastructure
```

## **🌍 Configuring Terraform Cloud**
If using **Terraform Cloud**, ensure:
1. **AWS credentials are stored in Terraform Cloud**:
   - `access_key`
   - `secret_key`
2. The **Terraform Working Directory** is set to:
   ```
   infra/
   ```
3. The workspace is configured to automatically trigger runs on new commits.

## **🐞 Troubleshooting**
### **Error: `No Terraform configuration files found in working directory`**
✔ **Solution**: Ensure Terraform Cloud is looking in the correct directory (`infra/`).

### **Error: `Unreadable module directory`**
✔ **Solution**: 
If the module is in `modules/S3/`, update `main.tf`:
```hcl
module "myBucket" {
  source = "./modules/S3"
}
```
Run `terraform init -reconfigure` to reload modules.


## **🔗 Useful Links**
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- [Infracost Documentation](https://www.infracost.io/docs/)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)

## **📌 Next Steps**
- Deploy new services (e.g., EC2-backend, EC2-frontend, RDS)
- Implement monitoring (CloudWatch, CloudTrail)
- Automate CI/CD for Terraform deployments
- Integrate Route 53 for domain management
- Create Auto Scaling Group for dynamic scaling
- Configure Launch Templates for backend and frontend instances
- Deploy an Application Load Balancer (ALB)
