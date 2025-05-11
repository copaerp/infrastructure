locals {
  lambda_handler       = "bootstrap"
  lambda_runtime       = "provided.al2023"
  lambda_architectures = ["arm64"]
}

resource "aws_lambda_function" "channel_dispatcher" {
  function_name = "channel-dispatcher"

  role    = var.iam_role_id
  handler = local.lambda_handler
  runtime = local.lambda_runtime

  architectures = local.lambda_architectures

  timeout     = 30
  memory_size = 128
}

resource "aws_lambda_function" "message_standardizer" {
  function_name = "message-standardizer"

  role    = var.iam_role_id
  handler = local.lambda_handler
  runtime = local.lambda_runtime

  architectures = local.lambda_architectures

  timeout     = 30
  memory_size = 128
}

resource "aws_lambda_function" "frontend_bridge" {
  function_name = "frontend-bridge"

  role    = var.iam_role_id
  handler = local.lambda_handler
  runtime = local.lambda_runtime

  architectures = local.lambda_architectures

  timeout     = 30
  memory_size = 128
}
