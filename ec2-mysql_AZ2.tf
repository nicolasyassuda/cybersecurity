resource "aws_security_group" "CyberSecurityMysqlSGAZ2" {
  name        = "mysql-accessAZ2-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id
  ingress {
    from_port   = 33306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.CyberSecurityInstanceWordPressAZ2.private_ip}/32"]
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

resource "aws_security_group" "CyberSecuritySshSGAZ2" {
  name        = "ssh-accessmysqlAZ2-sg"
  description = "Allow SSH and HTTP/HTTPS access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.CyberSecurityInstanceWordPressAZ2.private_ip}/32"]
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

resource "aws_eip" "CyberSecurityMysqlEIPAZ2" {
  associate_with_private_ip = true
}

resource "aws_eip_association" "CyberSecurityMysqlEIPAssociationAZ2" {
  allocation_id        = aws_eip.CyberSecurityMysqlEIPAZ2.id
  network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ2.id
}

resource "aws_network_interface" "CyberSecurityPrivateInterfaceAZ2" {
  subnet_id   = element(aws_subnet.private_subnets,1).id
  private_ips = ["172.16.0.196","172.16.0.197","172.16.0.198"]
  security_groups = [aws_security_group.CyberSecurityMysqlSGAZ2.id, aws_security_group.CyberSecuritySshSGAZ2.id]

  tags = {
    Name = "CyberSecurityPrivateInterfaceAZ2"
  }
}

resource "aws_instance" "CyberSecurityInstanceMysql_1_AZ2" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.CyberSecurityKeyPair.key_name

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ2"
  }

  network_interface {
    network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ2.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              EOF
}

resource "aws_instance" "CyberSecurityInstanceMysql_2_AZ2" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.CyberSecurityKeyPair.key_name

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ2"
  }

  network_interface {
    network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ2.id
    device_index         = 1
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              EOF
}

resource "aws_instance" "CyberSecurityInstanceMysql_3_AZ2" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.CyberSecurityKeyPair.key_name

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ2"
  }

  network_interface {
    network_interface_id = aws_network_interface.CyberSecurityPrivateInterfaceAZ2.id
    device_index         = 2
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              EOF
}