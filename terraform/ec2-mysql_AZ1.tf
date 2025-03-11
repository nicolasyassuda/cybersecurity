resource "aws_security_group" "CyberSecurityMysqlSGAZ1" {
  name        = "mysql-AZ1-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/26"] # Allow MySQL access from this CIDR block
  }

  ingress {
    from_port   = -1 
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.16.0.0/26"]
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
  description = "Allow SSH access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from anywhere (restrict this in production)
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

locals {
  private_ips = ["172.16.0.132", "172.16.0.133", "172.16.0.134"]
}

variable "privateIpsAZ1" {
  type        = list(string)
  description = "Private IPs for MySQL instances"
  default     = ["172.16.0.132", "172.16.0.133", "172.16.0.134"]
}

resource "aws_network_interface" "CyberSecurityPrivateInterfaceAZ1" {
  count           = 3
  subnet_id       = element(aws_subnet.private_subnets, 0).id
  private_ips     = [var.privateIpsAZ1[count.index]]
  security_groups = [
    aws_security_group.CyberSecurityMysqlSGAZ1.id,
    aws_security_group.CyberSecuritySshSGAZ1.id
  ]

  tags = {
    Name = "CyberSecurityPrivateInterfaceAZ1-${count.index + 1}"
  }
}

resource "aws_instance" "CyberSecurityInstanceMysqlAZ1" {
  count         = 3
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.CyberSecurityKeyPair.key_name
  subnet_id     = element(aws_subnet.private_subnets, 0).id
  private_ip    = element(var.privateIpsAZ1[*], count.index)
  vpc_security_group_ids = [
    aws_security_group.CyberSecurityMysqlSGAZ1.id,
    aws_security_group.CyberSecuritySshSGAZ1.id
  ]

  user_data = <<-EOF
              #!/bin/bash
                apt update -y
              EOF

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ1-${count.index + 1}"
  }
}