// Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  instance_tenancy     = "default"

  tags = {
    Name = "vpc"
  }
}

// Create 2 public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_cird[0]
  map_public_ip_on_launch = "true" //Makes subnet public
  tags = {
    Name = "public_subnet"
  }
}

// Create internet gateway to access to internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

// Configure route table
resource "aws_route_table" "public-crt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_route
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-crt"
  }
}

// Attach to subnet
resource "aws_route_table_association" "crta-public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-crt.id
}

// Create private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_cird[count.index]
  availability_zone = var.availability_zone[count.index]
  count             = length(var.private_cird)

  tags = {
    Name = "private_subnet-${count.index}"
  }
}

// Create bastion security group
resource "aws_security_group" "bastion_sg" {
  name    = "bastion_sg"
  vpc_id  = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.cidr_route}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_route}"]
  }

  tags = {
    Name = "bastion_sg"
  }
}

// Create instances security group
resource "aws_security_group" "host_sg" {
  name        = "host_sg"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.cidr_route}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
  from_port   = 0
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["${var.cidr_route}"]
  }

  tags = {
    Name = "host_sg"
  }
}

// Create nodes security group
resource "aws_security_group" "nodes_sg" {
  name        = "nodes_sg"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${var.cidr_route}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  ingress {
  from_port   = 0
  to_port     = 0
  protocol    = "tcp"
  cidr_blocks = ["${var.cidr_route}"]
  }

  tags = {
    Name = "nodes_sg"
  }
}
