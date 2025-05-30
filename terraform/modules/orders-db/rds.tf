resource "aws_db_instance" "orders_db" {
  identifier        = "orders-db"
  allocated_storage = 20
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"

  db_name  = "orders"
  username = "admin"
  password = "#Urubu100"

  skip_final_snapshot = true
  publicly_accessible = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name        = "orders-db"
    Environment = "production"
  }
}

output "orders_db_username" {
  value = aws_db_instance.orders_db.username
}
output "orders_db_password" {
  value = aws_db_instance.orders_db.password
}
output "orders_db_endpoint" {
  value = aws_db_instance.orders_db.endpoint
}
output "orders_db_name" {
  value = aws_db_instance.orders_db.db_name
}
