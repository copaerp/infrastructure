resource "aws_s3_bucket" "bronze" {
  bucket = "copas3-bronze" #${var.environment}
  tags = {
    Name        = "s3-bronze"
    # Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "bronze" {
  bucket = aws_s3_bucket.bronze.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "bronze" {
  bucket = aws_s3_bucket.bronze.id

  versioning_configuration {
    status = "Enabled"
  }
}


