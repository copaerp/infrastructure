resource "aws_db_instance" "copa_db" {
  identifier              = "copa-db-instance"
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "8.0.35"
  instance_class          = "db.t3.micro"
  username                = "copa_admin"
  password                = "#Urubu100"
  db_name                 = "copadb"
  skip_final_snapshot     = true
  publicly_accessible     = true

  tags = {
    Name        = "copadb"
    Environment = "Dev"
  }
}
