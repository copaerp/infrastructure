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

// IAM Default Role
variable "iam_role_name" {
  default = "LabRole"
}
data "aws_iam_role" "existing_role" {
  name = var.iam_role_name
}
variable "iam_role_id" {
  default = data.aws_iam_role.existing_role.arn
}
