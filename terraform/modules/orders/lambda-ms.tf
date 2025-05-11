# API Gateway

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
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.message_standardizer_integration.id}"
}

resource "aws_lambda_permission" "message_standardizer_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.message_standardizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.message_standardizer_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_domain_name" "message_standardizer_domain" {
  domain_name = "ms.api.copaerp.site"

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api_cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.api_cert_validation]
}

resource "aws_apigatewayv2_api_mapping" "message_standardizer_mapping" {
  api_id      = aws_apigatewayv2_api.message_standardizer_api.id
  domain_name = aws_apigatewayv2_domain_name.message_standardizer_domain.id
  stage       = aws_apigatewayv2_stage.message_standardizer_stage.id
}

resource "aws_acm_certificate_validation" "api_cert_validation" {
  certificate_arn         = aws_acm_certificate.api_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.api_validation : record.fqdn]
}

output "message_standardizer_api_endpoint" {
  value = "https://${aws_apigatewayv2_domain_name.message_standardizer_domain.domain_name}"
}

# ACM

resource "aws_acm_certificate" "api_cert" {
  domain_name       = "ms.api.copaerp.site"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "message-standardizer-api-cert"
    Environment = "production"
    Managed-by  = "terraform"
  }
}

# DNS Validation

resource "aws_route53_record" "api_validation" {
  for_each = {
    for dvo in aws_acm_certificate.api_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.route53_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

resource "aws_route53_record" "api_domain" {
  zone_id = var.route53_zone_id
  name    = "ms.api.copaerp.site"
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.message_standardizer_domain.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.message_standardizer_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
