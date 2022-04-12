provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    source  = "hashicorp/aws"
    version = "4.8.0"
  }
}

