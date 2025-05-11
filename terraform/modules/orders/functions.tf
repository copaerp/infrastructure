locals {
  lambda_handler       = "bootstrap"
  lambda_runtime       = "provided.al2023"
  lambda_architectures = ["arm64"]
  dummy_source_file    = "${path.root}/dummy_bootstrap.zip"
}

resource "aws_lambda_function" "channel_dispatcher" {
  function_name = "channel-dispatcher"

  role     = data.aws_iam_role.existing_role.arn
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  timeout     = 30
  memory_size = 128
}

resource "aws_lambda_function" "message_standardizer" {
  function_name = "message-standardizer"

  role     = data.aws_iam_role.existing_role.arn
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  timeout     = 30
  memory_size = 128
}

resource "aws_lambda_function" "frontend_bridge" {
  function_name = "frontend-bridge"

  role     = data.aws_iam_role.existing_role.arn
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  timeout     = 30
  memory_size = 128
}
