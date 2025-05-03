resource "aws_iam_policy" "parameter_store_policy" {
  name        = "n8n-parameter-store-policy"
  description = "Policy to allow access to Parameter Store parameters for n8n configuration"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = "arn:aws:ssm:*:*:parameter/copa-erp/domains/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "parameter_store_attachment" {
  role       = var.iam_role_id
  policy_arn = aws_iam_policy.parameter_store_policy.arn
}
