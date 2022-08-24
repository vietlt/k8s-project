// Create bastion host
resource "aws_instance" "bastion_host" {
  ami                         = var.ami_id
  instance_type               = var.instance_type1
  subnet_id                   = data.aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name                    = "justakey"
  security_groups             = [data.aws_security_group.bastion_sg.id]
  tags = {
    "Name" = "bastion_host"
  }
}

// Create master
resource "aws_instance" "master" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = data.aws_subnet.private_subnet[0].id
  security_groups = [data.aws_security_group.host_sg.id]
  key_name        = "justakey"
  tags = {
    "Name" = "Master"
  }
}

// Create nodes
resource "aws_instance" "nodes" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  count           = var.instance_number
  subnet_id       = data.aws_subnet.private_subnet[count.index+1].id
  key_name        = "justakey"
  security_groups = [data.aws_security_group.nodes_sg.id]
  tags = {
    "Name" = "Nodes-${count.index}"
  }
}

