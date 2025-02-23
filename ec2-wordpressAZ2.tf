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
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.micro"
  key_name = aws_key_pair.CyberSecurityKeyPair.key_name

  tags = {
    Name = "CyberSecurityInstanceWordPressAZ2"
  }

  network_interface {
    network_interface_id = aws_network_interface.CyberSecurityInterfaceAZ2.id
    device_index         = 0
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Welcome to My WordPress Site</h1>" | sudo tee /var/www/html/index.html
              EOF
}