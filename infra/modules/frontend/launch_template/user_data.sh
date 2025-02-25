#!/bin/bash
set -e

# 1. Update packages and install Docker
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io unzip

# 2. Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker ubuntu

# 3. Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws

# 4. Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v${docker_compose_version}/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# 5. Create application directory and navigate to it
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# 6. Download docker-compose from S3
aws s3 cp s3://${s3_bucket_name}/docker-compose-fe.yml docker-compose.yml

# 7. Get environment variables from Secrets Manager and create .env file
aws secretsmanager get-secret-value \
  --secret-id frontend-env-${s3_bucket_name} \
  --query 'SecretString' \
  --output text | jq -r 'to_entries | .[] | .key + "=" + .value' > .env 2>/dev/null

chmod 600 .env

# 8. Start the containers
docker-compose up -d --build

