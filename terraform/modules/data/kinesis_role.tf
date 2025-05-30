# resource "aws_iam_role" "this" {
#   name = "kinesis-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action = "sts:AssumeRole",
#         Principal = {
#           Service = "firehose.amazonaws.com"
#         },
#         Effect = "Allow",
#         Sid    = ""
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "this" {
#   role = aws_iam_role.this.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "s3:PutObject",
#           "s3:GetBucketLocation",
#           "s3:ListBucket"
#         ],
#         Resource = [
#           aws_s3_bucket.general_bronze.arn,
#           "${aws_s3_bucket.general_bronze.arn}/*"
#         ]
#       }
#     ]
#   })
# }
