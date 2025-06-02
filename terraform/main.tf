provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "copaerp-terraform-lock"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "copaerp-terraform-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }
}
