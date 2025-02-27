# Kooben Project Commands Reference

## Terraform Management
### Version Management (tfenv)
```bash
# Install specific Terraform version
tfenv install 1.10.5

# Set active Terraform version
tfenv use 1.10.5

# List available Terraform versions
tfenv list-remote

# List installed Terraform versions
tfenv list

# Format Terraform files recursively
terraform fmt -recursive 

# Generate infrastructure visualization graph
terraform graph | dot -Tsvg > documentation/graph.svg

# Validate Terraform configuration
terraform validate
```

## Security & Cost Analysis
```bash
# Login to Infracost for cost estimation
infracost auth login

# Generate cost breakdown
infracost breakdown --path ./infra
infracost breakdown --path ./infra --log-level=debug

# Run security scan
tfsec
```

## AWS Commands
```bash
# Get current AWS region from EC2 metadata
curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region

# Describe RDS instances endpoints
aws rds describe-db-instances --query 'DBInstances[*].[Endpoint.Address,Endpoint.Port]'
```

## Docker Commands
```bash
# View container logs
sudo docker logs -f koobenApp-dockereando

# View container environment variables
sudo docker exec -it koobenApp-dockereando env | grep DB_

# Access container shell
sudo docker exec -it koobenApp-dockereando sh
```

## Database Management
```bash
# Connect to RDS database
psql -h kooben-db-kooben-dev-frankfurt.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -d koobenDB -W

# Useful PostgreSQL commands
SHOW rds.force_ssl;  # Check if SSL is forced
SHOW ssl;           # Check SSL status
SELECT datname FROM pg_database;  # List databases
```

## System & Logging
```bash
# View cloud-init logs
sudo tail -f /var/log/cloud-init-output.log
cat /var/log/cloud-init-output.log

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)
```

// The database connection failed previously because the SSL configuration was incorrect.
// TypeORM expects an object when SSL is enabled, but we were passing only `true`.
// PostgreSQL requires a proper SSL configuration with `{ rejectUnauthorized: false }`
// to allow secure connections without verifying the certificate authority.
// By updating `ssl` to be an object instead of just `true`, the connection now works properly.