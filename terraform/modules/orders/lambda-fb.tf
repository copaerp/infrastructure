resource "aws_apigatewayv2_api" "frontend_bridge_api" {
  name          = "frontend-bridge-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins  = ["*"]
    allow_methods  = ["*"]
    allow_headers  = ["*"]
    expose_headers = ["*"]
    max_age        = 3600
  }
}

resource "aws_apigatewayv2_stage" "frontend_bridge_stage" {
  api_id      = aws_apigatewayv2_api.frontend_bridge_api.id
  name        = "prod"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "frontend_bridge_integration" {
  api_id             = aws_apigatewayv2_api.frontend_bridge_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.frontend_bridge.invoke_arn
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "frontend_bridge_route" {
  api_id    = aws_apigatewayv2_api.frontend_bridge_api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.frontend_bridge_integration.id}"
}

resource "aws_lambda_permission" "frontend_bridge_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.frontend_bridge.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.frontend_bridge_api.execution_arn}/*/*"
}
