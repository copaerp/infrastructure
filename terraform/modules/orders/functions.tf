locals {
  lambda_handler       = "bootstrap"
  lambda_runtime       = "provided.al2023"
  lambda_architectures = ["arm64"]
  dummy_source_file    = "${path.root}/dummy_bootstrap.zip"
  envs = {
    n8n_webhook_url         = "https://n8n.copaerp.site/webhook/"
    new_message_workflow_id = "aba98742-debe-4f62-a283-55519635318b"
    environment             = "prod"
    whatsapp_verify_token   = "your_verify_token"
  }
}

resource "aws_security_group" "lambda_sg" {
  name   = "lambda-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_role" "existing_role" {
  name = var.iam_role_id
}

resource "aws_lambda_function" "channel_dispatcher" {
  function_name = "channel-dispatcher"

  role     = data.aws_iam_role.existing_role.arn
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  vpc_config {
    subnet_ids         = [var.private_subnet_a_id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = local.envs
  }

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

  vpc_config {
    subnet_ids         = [var.private_subnet_a_id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = local.envs
  }

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

  vpc_config {
    subnet_ids         = [var.private_subnet_a_id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = local.envs
  }

  timeout     = 30
  memory_size = 128
}
