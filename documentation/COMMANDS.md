# Kooben Project Commands Reference

This document contains frequently used commands to manage different aspects of the Kooben project. It is organized by categories to facilitate consultation during development and operation of the project.

## Terraform Management

### Version Management (tfenv)
Commands to manage Terraform versions using tfenv, a crucial tool to maintain consistency in the development environment.

```bash
# Install a specific Terraform version (1.10.5 is the current project version)
tfenv install 1.10.5

# Set the active Terraform version for this project
tfenv use 1.10.5

# List all available Terraform versions in the remote repository
# Useful to check if there are new versions available
tfenv list-remote

# List locally installed Terraform versions
# Allows you to see which versions are available to use
tfenv list
```

### Terraform Development Commands
Essential commands for Terraform code development and maintenance.

```bash
# Recursively format all Terraform files to maintain a consistent style
# Recommended to run before each commit
terraform fmt -recursive 

# Generate a visual graph of the infrastructure defined by Terraform
# Requires GraphViz installed (brew install graphviz on macOS)
terraform graph | dot -Tsvg > documentation/graph.svg

# Validate Terraform configuration for syntactic or logical errors
# Good practice to run before terraform plan/apply
terraform validate
```

## Security & Cost Analysis
Tools to analyze the security and costs of the infrastructure.

```bash
# Log in to Infracost for cost estimation
# Only needed the first time you use Infracost
infracost auth login

# Generate a detailed breakdown of estimated infrastructure costs
# Useful before applying changes to understand the financial impact
infracost breakdown --path ./infra

# Version with higher level of detail for debugging cost issues
infracost breakdown --path ./infra --log-level=debug

# Run a security analysis on the Terraform configuration
# Identifies potential vulnerabilities and security issues
tfsec
```

## AWS Commands

### EC2 & Metadata
```bash
# Get the current AWS region from EC2 instance metadata
# Useful for scripts that need to know the region they're running in
curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region
```

### RDS
```bash
# Show endpoint addresses and ports of all RDS instances
# Useful for obtaining database connection information
aws rds describe-db-instances --query 'DBInstances[*].[Endpoint.Address,Endpoint.Port]'
```

### Route53 & ACM (Certificates)
```bash
# List hosted zones in Route53 filtering by the kooben.cc domain
aws route53 list-hosted-zones | grep kooben.cc

# List ACM certificates filtering by the kooben.cc domain
aws acm list-certificates | grep kooben.cc

# List ACM certificates for kooben.cc with JSON format for better visualization
aws acm list-certificates --query "CertificateSummaryList[?contains(DomainName, 'kooben.cc')]" | cat

# Show domain validation options for a specific certificate
# Useful for verifying validation status and required DNS records
aws acm describe-certificate --certificate-arn arn:aws:acm:eu-central-1:277707121152:certificate/c1bc5641-ad91-405f-96d7-2c6bfad1836c --query "Certificate.DomainValidationOptions" | cat
```

### Load Balancing
```bash
# List all target groups of the load balancer
# Shows names and ARNs in text format for easy reference
aws elbv2 describe-target-groups --query "TargetGroups[*].[TargetGroupName,TargetGroupArn]" --output text | cat
```

## Docker Commands
Commands to manage Docker containers of the application.

```bash
# Show backend container logs in real time (follow mode)
# Useful for live debugging
sudo docker logs -f koobenApp-dockereando

# Show database-related environment variables inside the container
# Useful for verifying database connection configuration
sudo docker exec -it koobenApp-dockereando env | grep DB_

# Open an interactive shell inside the container
# Allows you to run commands directly in the container environment
sudo docker exec -it koobenApp-dockereando sh
```

## Database Management
Commands to manage and query the PostgreSQL database.

```bash
# Connect to the RDS database with the psql client
# -h: host, -U: user, -d: database name, -W: prompt for password
psql -h kooben-db-kooben-dev-frankfurt.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -d koobenDB -W
```

### Useful PostgreSQL Queries
```sql
-- Check if SSL is forced on the RDS connection
SHOW rds.force_ssl;

-- Check the SSL status on the current connection
SHOW ssl;

-- List all databases on the PostgreSQL server
SELECT datname FROM pg_database;
```

## System & Logging
Commands for system management and log consultation.

```bash
# Show cloud-init initialization logs in real time
# Useful for diagnosing issues during instance startup
sudo tail -f /var/log/cloud-init-output.log

# Show the entire content of the cloud-init log
cat /var/log/cloud-init-output.log

# Load environment variables from a .env file to the current shell
# Useful for configuring the development or execution environment
export $(grep -v '^#' .env | xargs)
```

## Troubleshooting Notes

aws elbv2 describe-target-groups --query "TargetGroups[*].[TargetGroupName,TargetGroupArn]" --output text | cat