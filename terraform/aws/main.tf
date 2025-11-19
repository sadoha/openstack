provider "aws" {
  region = var.region
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet[count.index]
  #  availability_zone = var.azs[count.index]
  availability_zone = var.azs[0]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet[count.index]
  #  availability_zone = var.azs[count.index]
  availability_zone = var.azs[0]

  tags = {
    "Name" = "private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "internet-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_subnet_association" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-private-rt"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_nat_gateway" "main_nat_gateway" {
  allocation_id = aws_eip.main_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "main-nw"
  }
}

resource "aws_eip" "main_eip" {
  domain = "vpc"
  tags = {
    Name = "main-eip"
  }
}

resource "aws_route" "nat_gateway_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_nat_gateway.id

  depends_on = [ aws_eip.main_eip ]
}

resource "aws_security_group" "public_sg" {
  name = "public_security_groups"
  description = "public security group"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Full access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  tags = {
    Name = "public-security-groups"
  }
}

resource "aws_security_group" "private_sg" {
  name = "private_security_groups"
  description = "private security group"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Full access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = [ "::/0" ]
  }

  tags = {
    Name = "private-security-groups"
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh.private_key_pem
  filename        = "ssh-keys/private_ssh_key"
  file_permission = "0400"
}

resource "aws_key_pair" "main" {
  key_name   = "openstack"
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "aws_instance" "jumphost" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.main.key_name
  private_ip                  = "10.0.10.100"
  # This ensures a public IP is assigned
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  root_block_device {
    volume_size = 8
    volume_type = "standard"
    encrypted   = false
  }
  user_data = file("scripts/jumphost.sh")

  tags = {
    Name = "jumphost"
  }
}

resource "aws_instance" "controller" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t2.large"
  key_name                    = aws_key_pair.main.key_name
  private_ip                  = "10.0.2.11"
  subnet_id                   = aws_subnet.private_subnet[1].id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  root_block_device {
    volume_size = 16
    volume_type = "standard"
    encrypted   = false
  }

  tags = {
    Name = "controller"
  }
}

resource "aws_network_interface" "private_network_controller" {
  subnet_id       = aws_subnet.private_subnet[2].id
  security_groups = [aws_security_group.private_sg.id]
  private_ips     = ["10.0.3.11"]

  attachment {
    instance     = aws_instance.controller.id
    device_index = 2
  }
}

resource "aws_instance" "compute_01" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t2.large"
  key_name                    = aws_key_pair.main.key_name
  private_ip                  = "10.0.2.31"
  subnet_id                   = aws_subnet.private_subnet[1].id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  root_block_device {
    volume_size = 16
    volume_type = "standard"
    encrypted   = false
  }

  tags = {
    Name = "compute-01"
  }
}

resource "aws_network_interface" "private_network_compute_01" {
  subnet_id       = aws_subnet.private_subnet[2].id
  security_groups = [aws_security_group.private_sg.id]
  private_ips     = ["10.0.3.31"]

  attachment {
    instance     = aws_instance.compute_01.id
    device_index = 2
  }
}
/*
resource "aws_instance" "compute_02" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t2.large"
  key_name                    = aws_key_pair.main.key_name
  private_ip                  = "10.0.2.32"
  subnet_id                   = aws_subnet.private_subnet[1].id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  root_block_device {
    volume_size = 16
    volume_type = "standard"
    encrypted   = false
  }

  tags = {
    Name = "compute-02"
  }
}

resource "aws_network_interface" "private_network_compute_02" {
  subnet_id       = aws_subnet.private_subnet[2].id
  security_groups = [aws_security_group.private_sg.id]
  private_ips     = ["10.0.3.32"]

  attachment {
    instance     = aws_instance.compute_02.id
    device_index = 2
  }
}

resource "aws_instance" "block_storage" {
  ami                         = "ami-0360c520857e3138f"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.main.key_name
  private_ip                  = "10.0.2.41"
  subnet_id                   = aws_subnet.private_subnet[1].id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  root_block_device {
    volume_size = 8
    volume_type = "standard"
    encrypted   = false
  }

  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_size           = 16
    volume_type           = "standard"
    delete_on_termination = true
    encrypted             = false
    tags = {
      Name = "BlockStorageDataVolume"
    }
  }

  tags = {
    Name = "block-storage"
  }
}
*/
