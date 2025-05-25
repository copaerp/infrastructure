resource "aws_db_instance" "orders_db" {
  identifier        = "orders-db"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"

  db_subnet_group_name   = var.private_subnet_a_name
  vpc_security_group_ids = [aws_security_group.orders_db_sg]

  db_name  = "orders"
  username = "admin"
  password = "#Urubu100"

  publicly_accessible = false

  tags = {
    Name        = "orders-db"
    Environment = "production"
  }
}
