variable "domain_name" {
  default = "orders.copaerp.site"
}

# # ----------------------------
# # S3 Bucket (arquivos buildados)
# # ----------------------------
# resource "aws_s3_bucket" "frontend" {
#   bucket = "copaerp-orders-ui-bucket"
# }

# # ----------------------------
# # ACM Certificate
# # ----------------------------
# resource "aws_acm_certificate" "cert" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"
# }

# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       type   = dvo.resource_record_type
#       record = dvo.resource_record_value
#     }
#   }

#   zone_id = var.route53_main_zone_id
#   name    = each.value.name
#   type    = each.value.type
#   records = [each.value.record]
#   ttl     = 60
# }

# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# }

# # ----------------------------
# # ECS Cluster
# # ----------------------------
# resource "aws_ecs_cluster" "this" {
#   name = "orders-ui-cluster"
# }

# # ----------------------------
# # ECS Task Definition (NGINX)
# # ----------------------------
# resource "aws_ecs_task_definition" "nginx" {
#   family                   = "orders-ui-task"
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   execution_role_arn       = var.iam_role_id

#   container_definitions = jsonencode([
#     {
#       name      = "nginx"
#       image     = "nginx:stable"
#       essential = true
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#           protocol      = "tcp"
#         }
#       ]
#       command = [
#         "/bin/sh",
#         "-c",
#         "aws s3 sync s3://${aws_s3_bucket.frontend.bucket} /usr/share/nginx/html && nginx -g 'daemon off;'"
#       ]
#     }
#   ])
# }

# # ----------------------------
# # VPC + Networking
# # ----------------------------
# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }

# resource "aws_security_group" "alb_sg" {
#   vpc_id = data.aws_vpc.default.id
#   name   = "orders-ui-alb-sg"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "ecs_sg" {
#   vpc_id = data.aws_vpc.default.id
#   name   = "orders-ui-ecs-sg"

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = [aws_security_group.alb_sg.id]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # ----------------------------
# # ALB
# # ----------------------------
# resource "aws_lb" "this" {
#   name               = "orders-ui-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = data.aws_subnets.default.ids
# }

# resource "aws_lb_target_group" "this" {
#   name     = "orders-ui-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = data.aws_vpc.default.id
#   target_type = "ip"
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"
#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }

# # ----------------------------
# # ECS Service
# # ----------------------------
# resource "aws_ecs_service" "nginx" {
#   name            = "orders-ui-svc"
#   cluster         = aws_ecs_cluster.this.id
#   task_definition = aws_ecs_task_definition.nginx.arn
#   desired_count   = 1
#   launch_type     = "FARGATE"

#   network_configuration {
#     subnets          = data.aws_subnets.default.ids
#     security_groups  = [aws_security_group.ecs_sg.id]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.this.arn
#     container_name   = "nginx"
#     container_port   = 80
#   }

#   depends_on = [aws_lb_listener.https]
# }

# # ----------------------------
# # Route53 record
# # ----------------------------
# resource "aws_route53_record" "frontend_alias" {
#   zone_id = var.route53_main_zone_id
#   name    = var.domain_name
#   type    = "A"

#   alias {
#     name                   = aws_lb.this.dns_name
#     zone_id                = aws_lb.this.zone_id
#     evaluate_target_health = false
#   }
# }
