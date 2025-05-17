resource "aws_db_instance" "copa_db" {
  allocated_storage       = 10
  engine                  = "mysql"
  engine_version          = "8.0.35"
  instance_class          = "db.t3.micro"
  username                = "copa_admin"
  password                = "#Urubu100"
  db_name                 = "copadb"
  skip_final_snapshot     = true

  tags = {
    Name        = "copadb"
    Environment = "Dev"
  }
}



# resource "aws_db_instance" "copa_db" {
#   allocated_storage       = 20
#   storage_type            = "gp2"
#   engine                  = "postgres"
#   engine_version          = "12"
#   instance_class          = "db.t3.micro"
#   db_name                 = "copadb"
#   username                = "copa_admin"
#   password                = "#Urubu100"
#   skip_final_snapshot     = true
#   publicly_accessible     = false
#   multi_az                = false
#   backup_retention_period = 7
#   deletion_protection     = false

#   tags = {
#     Name        = "copadb"
#     Environment = "Dev"
#   }
# }
