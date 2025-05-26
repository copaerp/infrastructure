resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = var.firehose_role_arn
    bucket_arn         = var.bucket_arn
    buffering_size     = var.buffering_size
    buffering_interval = var.buffering_interval
    compression_format = var.compression_format
  }
}


