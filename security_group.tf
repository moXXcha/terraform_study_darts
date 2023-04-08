#------------------------------
# Security group
#------------------------------
//web
resource "aws_security_group" "web-sg" {
  name        = "${var.project}-${var.env}-web-sg"
  description = "web security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-web-sg"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_security_group_rule" "web-sg-ingress-http-rule" {
  security_group_id = aws_security_group.web-sg.id
  type              = "ingress"
  protocol          = "tcp"
  to_port           = 80
  from_port         = 80
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "web-sg-ingress-ssh-rule" {
  security_group_id = aws_security_group.web-sg.id
  type              = "ingress"
  protocol          = "tcp"
  to_port           = 22
  from_port         = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web-sg-ingress-grafana-rule" {
  security_group_id = aws_security_group.web-sg.id
  type              = "ingress"
  protocol          = "tcp"
  to_port           = 3000
  from_port         = 3000
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web-sg-egress-http-rule" {
  security_group_id = aws_security_group.web-sg.id
  type              = "egress"
  protocol          = "tcp"
  to_port           = 80
  from_port         = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web-sg-egress-https-rule" {
  security_group_id = aws_security_group.web-sg.id
  type              = "egress"
  protocol          = "tcp"
  to_port           = 443
  from_port         = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

//db
resource "aws_security_group" "db-sg" {
  name        = "${var.project}-${var.env}-db-sg"
  description = "db security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-db-sg"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_security_group_rule" "db-sg-ingress-ssh-rule" {
  security_group_id = aws_security_group.db-sg.id
  type              = "ingress"
  protocol          = "tcp"
  to_port           = 22
  from_port         = 22
  cidr_blocks       = ["10.0.0.0/16"]
}
resource "aws_security_group_rule" "db-sg-ingress-mysql-rule" {
  security_group_id = aws_security_group.db-sg.id
  type              = "ingress"
  protocol          = "tcp"
  to_port           = 3306
  from_port         = 3306
  cidr_blocks       = ["10.0.20.0/24"]
}
resource "aws_security_group_rule" "db-sg-egress-mysql-rule" {
  security_group_id = aws_security_group.db-sg.id
  type              = "egress"
  protocol          = "tcp"
  to_port           = 3306
  from_port         = 3306
  cidr_blocks       = ["10.0.20.0/24"]
}
//step
resource "aws_security_group" "step-sg" {
  name        = "${var.project}-${var.env}-step-sg"
  description = "step server sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-step-sg"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_security_group_rule" "step-sg-ingress-ssh-rule" {
  security_group_id = aws_security_group.step-sg.id
  type              = "ingress"
  protocol          = "tcp"
  to_port           = 22
  from_port         = 22
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "step-sg-egress-ssh-rule" {
  security_group_id        = aws_security_group.step-sg.id
  type                     = "egress"
  protocol                 = "tcp"
  to_port                  = 22
  from_port                = 22
  source_security_group_id = aws_security_group.db-sg.id
}
//lambda
resource "aws_security_group" "lambda-sg" {
  name        = "${var.project}-${var.env}-lambda-sg"
  description = "lambda sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-lambda-sg"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_security_group_rule" "lambda-sg-egress-mysql-rule" {
  security_group_id        = aws_security_group.lambda-sg.id
  type                     = "egress"
  protocol                 = "tcp"
  to_port                  = 3306
  from_port                = 3306
  source_security_group_id = aws_security_group.db-sg.id
}