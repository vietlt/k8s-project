data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["public_subnet"]
  }
}

data "aws_subnet" "private_subnet" {
  count = 3
  filter {
    name   = "tag:Name"
    values = ["private_subnet-${count.index}"]
  }
}

data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = ["vpc"]
  }
}

data "aws_security_group" "bastion_sg" {
  filter {
    name   = "tag:Name"
    values = ["bastion_sg"]
  }
}

data "aws_security_group" "host_sg" {
  filter {
    name   = "tag:Name"
    values = ["host_sg"]
  }
}

data "aws_security_group" "nodes_sg" {
  filter {
    name   = "tag:Name"
    values = ["nodes_sg"]
  }
}
