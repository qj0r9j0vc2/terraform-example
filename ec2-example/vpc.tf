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

//Public RouteTable Routing
resource "aws_route" "example-rt-public-route-1" {
  route_table_id = aws_route_table.example-rt-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.example-igw.id
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