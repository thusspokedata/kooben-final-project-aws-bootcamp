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
