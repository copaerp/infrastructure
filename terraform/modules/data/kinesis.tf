resource "aws_kinesis_firehose_delivery_stream" "general_kinesis" {
  name        = "firehose-copa"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.iam_role_id
    bucket_arn = aws_s3_bucket.general_bronze.arn
  }
}
