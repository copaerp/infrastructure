locals {
  lambda_handler       = "bootstrap"
  lambda_runtime       = "provided.al2023"
  lambda_architectures = ["arm64"]
  dummy_source_file    = "${path.root}/dummy_bootstrap.zip"
  envs = {
    whatsapp_api_url          = "https://graph.facebook.com/v22.0/"
    n8n_webhook_url           = "https://n8n.copaerp.site/webhook/"
    new_message_workflow_id   = "bf32139d-ca1f-4d01-bc45-9d4809368fa9"
    order_timeout_workflow_id = "0e0f95f5-c30b-43e8-b52d-65dc1a1684ee"
    environment               = "prod"
    whatsapp_verify_token     = "your_verify_token"
    orders_db_username        = var.orders_db_username
    orders_db_password        = var.orders_db_password
    orders_db_endpoint        = var.orders_db_endpoint
    orders_db_name            = var.orders_db_name
    role_arn                  = var.iam_role_id
  }

  ot_envs = {
    ot_arn = aws_lambda_function.orders_timeout.arn
  }

  ot_envs_group = merge(local.envs, local.ot_envs)
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_all" {
  name        = "lambda_allow_all"
  description = "Allow all egress"
  vpc_id      = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "channel_dispatcher" {
  function_name = "channel-dispatcher"

  role     = var.iam_role_id
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  environment {
    variables = local.ot_envs_group
  }

  timeout     = 30
  memory_size = 128
}

resource "aws_lambda_function" "message_standardizer" {
  function_name = "message-standardizer"

  role     = var.iam_role_id
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  environment {
    variables = local.ot_envs_group
  }

  timeout     = 30
  memory_size = 128
}

resource "aws_lambda_function" "frontend_bridge" {
  function_name = "frontend-bridge"

  role     = var.iam_role_id
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  environment {
    variables = local.ot_envs_group
  }

  timeout     = 30
  memory_size = 128
}

resource "aws_lambda_function" "orders_timeout" {
  function_name = "orders-timeout"

  role     = var.iam_role_id
  handler  = local.lambda_handler
  runtime  = local.lambda_runtime
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  environment {
    variables = local.envs
  }

  timeout     = 30
  memory_size = 128
}
