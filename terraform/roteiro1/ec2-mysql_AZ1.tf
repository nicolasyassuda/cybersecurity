resource "aws_security_group" "CyberSecurityMysqlSGAZ1" {
  name        = "mysql-AZ1-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/26"]
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
    cidr_blocks = ["172.16.0.0/26"]
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

variable "privateIpsAZ1" {
  type        = list(string)
  description = "Private IPs for MySQL instances"
  default     = ["172.16.0.132","172.16.0.133"]
}

resource "aws_network_interface" "CyberSecurityPrivateInterfaceAZ1" {
  subnet_id   = element(aws_subnet.private_subnets, 0).id
  private_ips = [element(var.privateIpsAZ1[*], 0)]
  security_groups = [
    aws_security_group.CyberSecurityMysqlSGAZ1.id,
    aws_security_group.CyberSecuritySshSGAZ1.id
  ]

  tags = {
    Name = "CyberSecurityPrivateInterfaceAZ1"
  }
}

resource "aws_instance" "CyberSecurityInstanceMysqlAZ1" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.CyberSecurityKeyPair.key_name
  subnet_id     = element(aws_subnet.private_subnets, 0).id
  private_ip    = element(var.privateIpsAZ1[*], 1)
  vpc_security_group_ids = [
    aws_security_group.CyberSecurityMysqlSGAZ1.id,
    aws_security_group.CyberSecuritySshSGAZ1.id
  ]

  depends_on = [
    aws_nat_gateway.NATGatewayPrivateNetwork,
    aws_route_table.CyberSecurityPrivateRouteTable
  ]

  user_data = file("${path.module}/mysql-userdata.sh")

  tags = {
    Name = "CyberSecurityInstanceMysqlAZ1"
  }
}
