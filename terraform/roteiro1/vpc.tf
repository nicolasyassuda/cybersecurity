data "aws_availability_zones" "available" {
  state = "available"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default     = ["172.16.0.0/26", "172.16.0.64/26"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
  default     = ["172.16.0.128/26", "172.16.0.192/26"]
}

resource "aws_vpc" "CyberSecurityVPC" {
  cidr_block           = "172.16.0.0/24"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "CyberSecurityVPC"
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.CyberSecurityVPC.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.CyberSecurityVPC.id
  count             = length(var.private_subnets_cidr)
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_internet_gateway" "CyberSecurityGateway" {
  vpc_id = aws_vpc.CyberSecurityVPC.id

  tags = {
    Name = "CyberSecurityGateway"
  }
}

resource "aws_route_table" "CyberSecuritySecondRouteTable" {
  vpc_id = aws_vpc.CyberSecurityVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CyberSecurityGateway.id
  }

  tags = {
    Name = "CyberSecuritySecondRouteTable"
  }
}

resource "aws_route_table_association" "PublicAssociationToSecondRouteTable" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.CyberSecuritySecondRouteTable.id
}

resource "aws_eip" "NATAllocation" {
  count = length(var.public_subnets_cidr)
  depends_on = [aws_internet_gateway.CyberSecurityGateway]
}

resource "aws_nat_gateway" "NATGatewayPrivateNetwork" {
  count         = length(var.public_subnets_cidr)
  allocation_id = aws_eip.NATAllocation[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  depends_on    = [aws_internet_gateway.CyberSecurityGateway]
}

resource "aws_route_table" "CyberSecurityPrivateRouteTable" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.CyberSecurityVPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.NATGatewayPrivateNetwork[*].id, count.index)
  }

  tags = {
    Name = "CyberSecurityPrivateRouteTable-${count.index + 1}"
  }
}

resource "aws_route_table_association" "PrivateAssociationToPrivateRouteTable" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.CyberSecurityPrivateRouteTable[*].id, count.index)
}