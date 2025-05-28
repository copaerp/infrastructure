resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.iam_role_id         
    bucket_arn = var.bucket_arn
  }
}

