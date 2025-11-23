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
    ifood_client_id           = "c2530aee-f8c3-47ab-a946-55a2d1bcef81"
    ifood_client_secret       = "hjh82u6s5ge6p1zw2w99j51sqzoh0889kw1iweeviuts3v6gppduiz1hce7zr33hrlnol48qwz0q9b00xaoewyd8f0a0rchwa4e"
    ifood_auth_url            = "https://merchant-api.ifood.com.br/authentication/v1.0/oauth/token"
    ifood_events_url          = "https://merchant-api.ifood.com.br/order/v1.0/events:polling"
    ifood_order_url           = "https://merchant-api.ifood.com.br/order/v1.0/orders/{order_id}"
    ifood_channel_id          = "8b848fb0-2b67-405c-998e-51df7324b665"
  }

  ot_envs = {
    ot_arn = aws_lambda_function.orders_timeout.arn
  }

  ot_envs_group = merge(local.envs, local.ot_envs)
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

resource "aws_lambda_layer_version" "ifood_sync_dependencies" {
  layer_name               = "ifood-sync-dependencies"
  filename                 = "${path.root}/dummy_layer.zip"
  compatible_runtimes      = ["python3.13"]
  compatible_architectures = ["arm64"]

  lifecycle {
    ignore_changes = [filename, source_code_hash]
  }
}

resource "aws_lambda_function" "ifood_sync" {
  function_name = "ifood-sync"

  role     = var.iam_role_id
  handler  = "lambda_function.lambda_handler"
  runtime  = "python3.13"
  filename = local.dummy_source_file

  architectures = local.lambda_architectures

  layers = [aws_lambda_layer_version.ifood_sync_dependencies.arn]

  environment {
    variables = local.ot_envs_group
  }

  timeout     = 30
  memory_size = 128
}
