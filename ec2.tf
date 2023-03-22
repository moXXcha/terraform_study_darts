#------------------------------
# Key pair
#------------------------------
resource "aws_key_pair" "key-pair" {
  key_name   = "${var.project}-${var.env}-keypair"
  public_key = file("./src/darts-dev-terraform-key-pair.pub")

  tags = {
    Name    = "${var.project}-${var.env}-keypair"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# EC2
#------------------------------
resource "aws_instance" "web-server" {
  ami                         = "ami-030cf0a1edb8636ab"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key-pair.key_name
  vpc_security_group_ids = [
    aws_security_group.web-sg.id
  ]
  subnet_id = aws_subnet.public_subnet-1a.id

  tags = {
    Name    = "${var.project}-${var.env}-webserver"
    Project = var.project
    Env     = var.env
    Type    = "web"
  }
}

resource "aws_instance" "step-server" {
  ami                         = "ami-030cf0a1edb8636ab"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = aws_key_pair.key-pair.key_name
  vpc_security_group_ids = [
    aws_security_group.step-sg.id
  ]
  subnet_id = aws_subnet.public_subnet-1a.id

  tags = {
    Name    = "${var.project}-${var.env}-stepserver"
    Project = var.project
    Env     = var.env
    Type    = "step"
  }
}

resource "aws_instance" "db-server" {
  ami                         = "ami-030cf0a1edb8636ab"
  instance_type               = "t2.micro"
  associate_public_ip_address = false
  key_name                    = aws_key_pair.key-pair.key_name
  vpc_security_group_ids = [
    aws_security_group.db-sg.id
  ]
  subnet_id = aws_subnet.private_subnet-1a.id

  tags = {
    Name    = "${var.project}-${var.env}-dbserver"
    Project = var.project
    Env     = var.env
    Type    = "db"
  }
}