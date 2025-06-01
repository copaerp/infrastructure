locals {
  lambda_handler       = "bootstrap"
  lambda_runtime       = "provided.al2023"
  lambda_architectures = ["arm64"]
  dummy_source_file    = "${path.root}/dummy_bootstrap.zip"
  envs = {
    whatsapp_api_url        = "https://graph.facebook.com/v22.0/"
    n8n_webhook_url         = "https://n8n.copaerp.site/webhook/"
    new_message_workflow_id = "998ea582-5067-4362-b677-96c6f9991a7f"
    environment             = "prod"
    whatsapp_verify_token   = "your_verify_token"
    orders_db_username      = var.orders_db_username
    orders_db_password      = var.orders_db_password
    orders_db_endpoint      = var.orders_db_endpoint
    orders_db_name          = var.orders_db_name
    cd_arn                  = aws_lambda_function.channel_dispatcher.arn
    ms_arn                  = aws_lambda_function.message_standardizer.arn
    fb_arn                  = aws_lambda_function.frontend_bridge.arn
    ot_arn                  = aws_lambda_function.orders_timeout.arn
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
    variables = local.envs
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
    variables = local.envs
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
    variables = local.envs
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

  vpc_config {
    subnet_ids         = data.aws_subnets.public.ids
    security_group_ids = [aws_security_group.allow_all.id]
  }

  timeout     = 30
  memory_size = 128
}
