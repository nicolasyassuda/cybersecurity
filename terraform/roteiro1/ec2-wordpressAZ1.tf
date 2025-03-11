resource "aws_security_group" "CyberSecuritySG" {
  name        = "ssh-access-sg"
  description = "Allow SSH and HTTP/HTTPS access"
  vpc_id      = aws_vpc.CyberSecurityVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
resource "aws_eip" "CyberSecurityEIPAZ1" {
  associate_with_private_ip = true
}

resource "aws_eip_association" "CyberSecurityEIPAssociationAZ1" {
  allocation_id        = aws_eip.CyberSecurityEIPAZ1.id
  network_interface_id = aws_network_interface.CyberSecurityInterfaceAZ1.id
}

resource "aws_network_interface" "CyberSecurityInterfaceAZ1" {
  subnet_id   = element(aws_subnet.public_subnets,0).id
  private_ips = ["172.16.0.4"]
  security_groups = [aws_security_group.CyberSecuritySG.id]

  tags = {
    Name = "CyberSecurityInterfaceAZ1"
  }
}

resource "aws_instance" "CyberSecurityInstanceWordPressAZ1" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.CyberSecurityKeyPair.key_name
  subnet_id     = element(aws_subnet.public_subnets, 0).id 
  vpc_security_group_ids = [
    aws_security_group.CyberSecuritySG.id,
  ]
  depends_on = [ aws_instance.CyberSecurityInstanceMysqlAZ1 ]
  user_data = file("${path.module}/wordpress-userdata.sh")

  tags = {
    Name = "CyberSecurityInstanceWordPressAZ1"
  }
}