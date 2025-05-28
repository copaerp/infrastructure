variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  default = "default-key"
}

variable "ami_id" {
  default = "ami-08b5b3a93ed654d19" // Amazon Linux 2023 AMI
}

variable "account_id" {
  default = "390251560541"
}

variable "iam_role_id" {
  default = "LabRole"
}

locals {
  iam_role_arn = "arn:aws:iam::${var.account_id}:role/${var.iam_role_id}"
}

# variable "bucket_name" {
#   description = "Bucket s3-bronze"
#   type        = string
# }

# variable "environment" {
#   description = "Ambiente de deployment"
#   type        = string
# }
