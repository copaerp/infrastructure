locals {
  lambda_handler       = "bootstrap"
  lambda_runtime       = "provided.al2023"
  lambda_architectures = ["arm64"]
  dummy_source_file    = "${path.root}/dummy_bootstrap.zip"
  envs = {
    whatsapp_api_url         = "https://graph.facebook.com/v22.0/622466564276838/messages"
    n8n_webhook_url          = "https://n8n.copaerp.site/webhook/"
    new_message_workflow_id  = "aba98742-debe-4f62-a283-55519635318b"
    environment              = "prod"
    whatsapp_verify_token    = "your_verify_token"
    orders_db_connection_url = var.orders_db_connection_url
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

  environment {
    variables = local.envs
  }

  timeout     = 30
  memory_size = 128
}
