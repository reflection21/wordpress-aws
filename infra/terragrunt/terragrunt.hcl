locals {
  deployment_prefix = "spline"
  aws_region        = "eu-north-1"

  default_tags = {
    "TerminationDate"  = "Permanent",
    "Environment"      = "dev",
    "Team"             = "DevOps",
    "DeployedBy"       = "Terragrunt",
    "OwnerEmail"       = "artembrigaz@gmail.com"
    "DeploymentPrefix" = local.deployment_prefix
  }

}
# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "infra-state-wordpress-site-reflection2111"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    encrypt        = true
    s3_bucket_tags = local.default_tags
    use_lockfile   = true
  }
}

# Generate an AWS version block
generate "version" {
  path      = "version.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
  tags = var.default_tags
  }
}

variable "aws_region" {
  type        =  string
  description = "AWS Region."
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags for AWS that will be attached to each resource."
}
EOF
}

retryable_errors = [
  "(?s).*Error.*Required plugins are not installed.*"
]

inputs = {
  aws_region        = local.aws_region
  deployment_prefix = local.deployment_prefix
  default_tags      = local.default_tags
}
