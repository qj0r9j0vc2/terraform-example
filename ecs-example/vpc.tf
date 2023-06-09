//VPC
resource "aws_vpc" "example-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    service = "example"
    Name = "example-vpc"
  }
}

//PublicSubnetA
resource "aws_subnet" "example-subnet-publicA" {
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2a"
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-subnet-publicA"
  }
}

//PublicSubnetB
resource "aws_subnet" "example-subnet-publicB" {
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2b"
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-subnet-publicB"
  }
}

//PrivateSubnetA
resource "aws_subnet" "example-subnet-privateA" {
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2a"
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-subnet-privateA"
  }
}

//PrivateSubnetB
resource "aws_subnet" "example-subnet-privateB" {
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2b"
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-subnet-privateB"
  }
}

//InternetGateway
resource "aws_internet_gateway" "example-igw" {
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-igw"
  }
}

//EIP
resource "aws_eip" "example-eip" {
  vpc = true
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "example-eip"
  }
}

//NAT Gateway
resource "aws_nat_gateway" "example-ngw" {
  allocation_id = aws_eip.example-eip.id
  subnet_id = aws_subnet.example-subnet-publicA.id

  tags = {
    service = "example"
    Name = "example-ngw"
  }
}

//Public RouteTable
resource "aws_route_table" "example-rt-public" {
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-rt-public"
  }
}

resource "aws_route_table_association" "example-rt-public-association-1" {
  route_table_id = aws_route_table.example-rt-public.id
  subnet_id = aws_subnet.example-subnet-publicA.id
}

resource "aws_route_table_association" "example-rt-public-association-2" {
  route_table_id = aws_route_table.example-rt-public.id
  subnet_id = aws_subnet.example-subnet-publicB.id
}

//Public RouteTable Routing
resource "aws_route" "example-rt-public-route-1" {
  route_table_id = aws_route_table.example-rt-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.example-igw.id
}

//PrivateA RouteTable
resource "aws_route_table" "example-rt-privateA" {
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-rt-privateA"
  }
}

//PrivateA RouteTableAssociation
resource "aws_route_table_association" "example-rt-privateA-association-1" {
  route_table_id = aws_route_table.example-rt-privateA.id
  subnet_id = aws_subnet.example-subnet-privateA.id
}

//PrivateA RouteTable Routing
resource "aws_route" "example-rt-privateA-route-1" {
  route_table_id = aws_route_table.example-rt-privateA.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example-ngw.id
}

//PrivateB RouteTable
resource "aws_route_table" "example-rt-privateB" {
  vpc_id = aws_vpc.example-vpc.id

  tags = {
    service = "example"
    Name = "example-rt-privateB"
  }
}

//PrivateB RouteTableAssociation
resource "aws_route_table_association" "example-rt-privateB-association-1" {
  route_table_id = aws_route_table.example-rt-privateB.id
  subnet_id = aws_subnet.example-subnet-privateB.id
}

//PrivateB RouteTable Routing
resource "aws_route" "example-rt-privateB-route-1" {
  route_table_id = aws_route_table.example-rt-privateB.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.example-ngw.id
}


//SecurityGroup for SSH
resource "aws_security_group" "example-sg-ssh" {
  name = "example-sg-ssh"
  description = "Allow 22 port for SSH"
  vpc_id = aws_vpc.example-vpc.id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//SecurityGroup for HTTP
resource "aws_security_group" "example-sg-http" {
  name = "example-sg-http"
  description = "Allow 80 port for HTTP"
  vpc_id = aws_vpc.example-vpc.id
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//SecurityGroup for Default
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.example-vpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}