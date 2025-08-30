resource "aws_ecr_repository" "orders_ui_nginx" {
  name                 = "orders-ui-nginx-s3"
  image_tag_mutability = "MUTABLE"
  tags = {
    Project = "orders-ui"
  }
}
