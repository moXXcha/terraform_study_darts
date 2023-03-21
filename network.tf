#------------------------------
# VPC
#------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project}-${var.env}-vpc"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# Subnet
#------------------------------
resource "aws_subnet" "public_subnet-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name    = "${var.project}-${var.env}-public-subnet-1a"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_subnet" "private_subnet-1a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name    = "${var.project}-${var.env}-private-subnet-1a"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# igw
#------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-igw"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# Route table
#------------------------------
resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name    = "${var.project}-${var.env}-public-rt"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id
  route  = []

  tags = {
    Name    = "${var.project}-${var.env}-private-rt"
    Project = var.project
    Env     = var.env
  }
}
#------------------------------
# Route table assosiation
#------------------------------
resource "aws_route_table_association" "public-rt-association" {
  subnet_id      = aws_subnet.public_subnet-1a.id
  route_table_id = aws_route_table.public-rt.id
}
resource "aws_route_table_association" "private-rt-association" {
  subnet_id      = aws_subnet.private_subnet-1a.id
  route_table_id = aws_route_table.private-rt.id
}