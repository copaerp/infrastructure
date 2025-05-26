variable "role_name" {
  description = "Nome da role IAM para Kinesis Firehose"
  type        = string
}

variable "bucket_arn" {
  description = "ARN do bucket S3 para as permissões"
  type        = string
}
