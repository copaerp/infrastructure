provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "copaerp-terraform-lock-v2"
    use_lockfile   = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "copaerp-terraform-lock"
    encrypt        = true
  }
}
