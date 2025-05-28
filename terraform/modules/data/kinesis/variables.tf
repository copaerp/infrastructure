variable "name" {
  description = "Nome do delivery stream do Kinesis Firehose"
  type        = string
}

variable "iam_role_id" {
  description = "IAM role ARN for Firehose"
  type        = string
}

# variable "firehose_role_arn" {
#   description = "ARN da IAM Role do Firehose"
#   type        = string
# }

variable "bucket_arn" {
  description = "ARN do bucket S3 para destino"
  type        = string
}

variable "buffering_size" {
  description = "Tamanho do buffer em MB"
  type        = number
  default     = 128
}

variable "buffering_interval" {
  description = "Intervalo de buffering em segundos"
  type        = number
  default     = 300
}

variable "compression_format" {
  description = "Formato de compressão"
  type        = string
  default     = "UNCOMPRESSED"
}
