resource "aws_db_instance" "copa_db" {
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = "12"                     
  instance_class            = "db.t2.micro"                 
  db_name                   = "copadb"
  username                  = "admin"
  password                  = "#Urubu100"
  parameter_group_name      = "default.postgres14"
  skip_final_snapshot       = true
  publicly_accessible       = false
  multi_az                  = false
  backup_retention_period   = 7
  deletion_protection       = false

  tags = {
    Name        = "copadb"
    Environment = "Dev"
  }
}


