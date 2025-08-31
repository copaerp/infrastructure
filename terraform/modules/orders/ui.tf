variable "domain_name" {
  default = "orders.copaerp.site"
}

# ----------------------------
# S3 Bucket (arquivos buildados)
# ----------------------------
resource "aws_s3_bucket" "frontend" {
  bucket = "copaerp-orders-ui-bucket"
}

# Cluster ECS
resource "aws_ecs_cluster" "orders" {
  name = "orders-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "orders_ui" {
  family                   = "orders-ui"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name  = "orders-ui"
    image = "nginx:latest"
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

# Service ECS (usa default VPC/subnets automaticamente)
resource "aws_ecs_service" "orders_ui" {
  name            = "orders-ui"
  cluster         = aws_ecs_cluster.orders.id
  task_definition = aws_ecs_task_definition.orders_ui.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = true
    # se não informar subnets, Terraform vai reclamar
    # então você pode buscar as subnets default com data sources
    subnets = data.aws_subnets.default.ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.orders_ui.arn
    container_name   = "orders-ui"
    container_port   = 80
  }
}

# Descobrir subnets da VPC default
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ALB
resource "aws_lb" "orders_ui" {
  name               = "orders-ui"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "orders_ui" {
  name        = "orders-ui"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "ip"
}

resource "aws_lb_listener" "orders_ui" {
  load_balancer_arn = aws_lb.orders_ui.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.orders_ui.arn
  }
}

# DNS
resource "aws_route53_record" "orders_ui" {
  zone_id = var.route53_main_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.orders_ui.dns_name
    zone_id                = aws_lb.orders_ui.zone_id
    evaluate_target_health = true
  }
}
