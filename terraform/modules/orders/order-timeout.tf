data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
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

resource "aws_scheduler_schedule_group" "order_group" {
  name = "order-lifecycle"
}

resource "aws_scheduler_connection" "order_connection" {
  name               = "order-external-api-connection"
  authorization_type = "NONE"
  auth_parameters {
    invocation_http_parameters {
      endpoint = "https://n8n.copaerp.site/webhook/998ea582-5067-4362-b677-96c6f9991a7f"
    }
  }
}
