resource "aws_apigatewayv2_api" "message_standardizer_api" {
  name          = "message-standardizer-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "PUT", "DELETE"]
    allow_headers = ["Content-Type", "Authorization"]
  }
}

resource "aws_apigatewayv2_stage" "message_standardizer_stage" {
  api_id      = aws_apigatewayv2_api.message_standardizer_api.id
  name        = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "message_standardizer_integration" {
  api_id             = aws_apigatewayv2_api.message_standardizer_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.message_standardizer.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "message_standardizer_route" {
  api_id    = aws_apigatewayv2_api.message_standardizer_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.message_standardizer_integration.id}"
}

resource "aws_lambda_permission" "message_standardizer_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.message_standardizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.message_standardizer_api.execution_arn}/*/*"
}
