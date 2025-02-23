resource "aws_security_group" "CyberSecurityMysqlSGAZ1" {
  name        = "mysql-AZ1-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id
  ingress {
    from_port   = 33306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.CyberSecurityInstanceWordPressAZ1.private_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySQL-Security-Group"
  }
}

resource "aws_security_group" "CyberSecuritySshSGAZ1" {
  name        = "ssh-accessmysqlAZ1-sg"
  description = "Allow SSH and HTTP/HTTPS access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.CyberSecurityInstanceWordPressAZ1.private_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH-Security-Group"
  }
}

resource "aws_eip" "CyberSecurityMysqlEIPAZ1" {
  associate_with_private_ip = true
}

resource "aws_eip_association" "CyberSecurityMysqlEIPAssociationAZ1" {
  allocation_id        = aws_eip.CyberSecurityMysqlEIPAZ1.id
  network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ1.id
}

resource "aws_network_interface" "CyberSecurityPrivateInterfaceAZ1" {
  subnet_id   = element(aws_subnet.private_subnets,0).id
  private_ips = ["172.16.0.132","172.16.0.133","172.16.0.134"]
  security_groups = [aws_security_group.CyberSecurityMysqlSGAZ1.id, aws_security_group.CyberSecuritySshSGAZ1.id]

  tags = {
    Name = "CyberSecurityPrivateInterfaceAZ1"
  }
}

resource "aws_instance" "CyberSecurityInstanceMysql_1_AZ1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.CyberSecurityKeyPair.key_name

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ1"
  }

  network_interface {
    network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ1.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              EOF
}

resource "aws_instance" "CyberSecurityInstanceMysql_2_AZ1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.CyberSecurityKeyPair.key_name

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ1"
  }

  network_interface {
    network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ1.id
    device_index         = 1
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              EOF
}

resource "aws_instance" "CyberSecurityInstanceMysql_3_AZ1" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.CyberSecurityKeyPair.key_name

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ1"
  }

  network_interface {
    network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ1.id
    device_index         = 2
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              EOF
}