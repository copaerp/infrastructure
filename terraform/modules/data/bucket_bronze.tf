resource "aws_s3_bucket" "general_bronze" {
  bucket = "copa-general-bronze"
  tags = {
    Name = "copa-general-bronze"
  }
}

resource "aws_s3_bucket_public_access_block" "general_bronze" {
  bucket = aws_s3_bucket.general_bronze.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "general_bronze" {
  bucket = aws_s3_bucket.general_bronze.id

  versioning_configuration {
    status = "Enabled"
  }
}
