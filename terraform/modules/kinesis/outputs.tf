output "delivery_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.this.name
}

output "delivery_stream_arn" {
  value = aws_kinesis_firehose_delivery_stream.this.arn
}
