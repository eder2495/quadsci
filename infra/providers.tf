terraform {
  backend "s3" {
    bucket       = "quadsci-tfstate-227976677859-us-east-1"
    key          = "quadsci-challenge/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}