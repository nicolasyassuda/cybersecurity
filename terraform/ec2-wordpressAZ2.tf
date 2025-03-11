resource "aws_eip" "CyberSecurityEIPAZ2" {
  associate_with_private_ip = true
}

resource "aws_eip_association" "CyberSecurityEIPAssociationAZ2" {
  allocation_id        = aws_eip.CyberSecurityEIPAZ2.id
  network_interface_id = aws_network_interface.CyberSecurityInterfaceAZ2.id
}

resource "aws_network_interface" "CyberSecurityInterfaceAZ2" {
  subnet_id   = element(aws_subnet.public_subnets,1).id
  private_ips = ["172.16.0.68"]
  security_groups = [aws_security_group.CyberSecuritySG.id]

  tags = {
    Name = "CyberSecurityInterfaceAZ2"
  }
}

resource "aws_instance" "CyberSecurityInstanceWordPressAZ2" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.CyberSecurityKeyPair.key_name
  subnet_id     = element(aws_subnet.public_subnets, 1).id 
  vpc_security_group_ids = [
    aws_security_group.CyberSecuritySG.id,
  ]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install apache2 -y
              systemctl start apache2
              systemctl enable apache2
              echo "<h1>Welcome to My WordPress Site</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "CyberSecurityInstanceWordPressAZ2"
  }
}