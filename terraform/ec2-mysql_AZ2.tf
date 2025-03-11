resource "aws_security_group" "CyberSecurityMysqlSGAZ2" {
  name        = "mysql-AZ2-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.64/26"] # Allow access only from this CIDR block
  }

  ingress {
    from_port   = -1 
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.16.0.64/26"]
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

variable "privateIpsAZ2" {
  type        = list(string)
  description = "Private IPs for MySQL instances"
  default     = ["172.16.0.196", "172.16.0.197", "172.16.0.198"]
}

resource "aws_network_interface" "CyberSecurityPrivateInterfaceAZ2" {
  count           = 3
  subnet_id       = element(aws_subnet.private_subnets, 1).id
  private_ips     = [var.privateIpsAZ2[count.index]]
  security_groups = [
    aws_security_group.CyberSecurityMysqlSGAZ2.id,
    aws_security_group.CyberSecuritySshSGAZ2.id
  ]

  tags = {
    Name = "CyberSecurityPrivateInterfaceAZ2-${count.index + 1}"
  }
}

resource "aws_instance" "CyberSecurityInstanceMysqlAZ2" {
  count         = 3
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.CyberSecurityKeyPair.key_name
  subnet_id     = element(aws_subnet.private_subnets, 1).id 
  private_ip    = element(var.privateIpsAZ2[*], count.index)

  vpc_security_group_ids = [
    aws_security_group.CyberSecurityMysqlSGAZ2.id,
    aws_security_group.CyberSecuritySshSGAZ2.id
  ]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              EOF

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ2-${count.index + 1}"
  }
}