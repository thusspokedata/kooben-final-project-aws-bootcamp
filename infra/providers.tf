terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.0"
    }
    random = { # this is a provider for generating random strings
      source  = "hashicorp/random" 
      version = "3.6.3"
    }

  }
  required_version = "~>1.10.5"
}

provider "aws" {
  region = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = var.tags
  }
}