terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"  # ~> 6.0 max version
    }
  }
  required_version = ">= 1.0.2"
}
