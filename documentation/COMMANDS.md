# ----------------------------------------
# Terraform Version Management (tfenv)
# ----------------------------------------

# Install Terraform version 1.10.5
```bash
tfenv install 1.10.5
```

# Set Terraform to use version 1.10.5
```bash
tfenv use 1.10.5
```

# List all available Terraform versions from the remote repository
```bash
tfenv list-remote
```

# List all installed Terraform versions on your machine
```bash
tfenv list
```

# ----------------------------------------
# Security & Cost Analysis
# ----------------------------------------

# Authenticate Infracost to enable cost estimation
```bash
infracost auth login
```

# Generate a cost breakdown for the Terraform configuration

```bash
infracost breakdown --path ./infra
```

# Run a security scan on the Terraform configuration using tfsec
```bash
tfsec
```


# ----------------------------------------
# Linting & Validation
# ----------------------------------------

# Install TFLint, a Terraform linter (if not installed)
```bash
brew install tflint
```

# Validate the Terraform configuration files
```bash
terraform validate
```


terraform fmt -recursive 

curl http://169.254.169.254/latest/dynamic/instance-identity/document | grep region


sudo tail -f /var/log/cloud-init-output.log

cat /var/log/cloud-init-output.log


sudo docker logs -f koobenApp-dockereando

sudo docker exec -it koobenApp-dockereando env | grep DB_

aws rds describe-db-instances --query 'DBInstances[*].[Endpoint.Address,Endpoint.Port]'



sudo docker exec -it koobenApp-dockereando sh
cat /app/src/config/database.config.ts

psql -h database-1.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -d koobenDB -W

export $(grep -v '^#' .env | xargs)

psql -h kooben-db-kooben-dev-frankfurt.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -W
psql -h database-1.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -W

database-1.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com

sudo docker exec -it koobenApp-dockereando psql -h database-1.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -d koobenDB -W
sudo docker exec -it kooben-db-kooben-dev-frankfurt.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -d koobenDB -W


# working
psql -h kooben-db-kooben-dev-frankfurt.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -U koobendb -d koobenDB -W
psql -h database-1.cfqwsm2ayq93.eu-central-1.rds.amazonaws.com -d koobenDB -W


SHOW rds.force_ssl;

SELECT datname FROM pg_database;

SHOW ssl;


// The database connection failed previously because the SSL configuration was incorrect.
// TypeORM expects an object when SSL is enabled, but we were passing only `true`.
// PostgreSQL requires a proper SSL configuration with `{ rejectUnauthorized: false }`
// to allow secure connections without verifying the certificate authority.
// By updating `ssl` to be an object instead of just `true`, the connection now works properly.