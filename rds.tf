#------------------------------
# RDS
#------------------------------
resource "aws_db_instance" "database" {
  identifier                  = "${var.project}-${var.env}-db"
  instance_class              = "db.t2.micro"
  name                        = "test"
  engine                      = "mysql"
  engine_version              = "8.0.23"
  db_subnet_group_name        = aws_db_subnet_group.subnet-group.name
  option_group_name           = aws_db_option_group.option-group.name
  parameter_group_name        = aws_db_parameter_group.parameter-group.name
  port                        = 3306
  allocated_storage           = 10
  allow_major_version_upgrade = true
  apply_immediately           = false
  auto_minor_version_upgrade  = true
  availability_zone           = "ap-northeast-1a"
  delete_automated_backups    = true
  deletion_protection         = false
  multi_az                    = false
  password                    = random_string.db-pass.result
  storage_type                = "gp2"
  username                    = "dbuser"
  vpc_security_group_ids = [
    aws_security_group.db-sg.id
  ]

  tags = {
    Name    = "${var.project}-${var.env}-db"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# Prameter Group
#------------------------------
resource "aws_db_parameter_group" "parameter-group" {
  name   = "${var.project}-${var.env}-parameter-group"
  family = "mysql8.0"
  parameter {
    name  = "character_set_database"
    value = "utf8mb4"
  }
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  tags = {
    Name    = "${var.project}-${var.env}-parameter-group"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# Option Group
#------------------------------
resource "aws_db_option_group" "option-group" {
  name                 = "${var.project}-${var.env}-option-group"
  engine_name          = "mysql"
  major_engine_version = "8.0"

  tags = {
    Name    = "${var.project}-${var.env}-option-group"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# Subnet Group
#------------------------------
resource "aws_db_subnet_group" "subnet-group" {
  name = "${var.project}-${var.env}-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet-1a.id,
    aws_subnet.private_subnet-1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.env}-subnet-group"
    Project = var.project
    Env     = var.env
  }
}

resource "random_string" "db-pass" {
  length  = 10
  special = false
}