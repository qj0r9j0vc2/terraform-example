//VPC
resource "aws_vpc" "sample-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  instance_tenancy = "default"

  tags = {
    service = "sample"
    Name = "sample-vpc"
  }
}

//PublicSubnetA
resource "aws_subnet" "sample-subnet-publicA" {
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2a"
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-subnet-publicA"
  }
}

//PublicSubnetB
resource "aws_subnet" "sample-subnet-publicB" {
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2b"
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-subnet-publicB"
  }
}

//PrivateSubnetA
resource "aws_subnet" "sample-subnet-privateA" {
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2a"
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-subnet-privateA"
  }
}

//PrivateSubnetB
resource "aws_subnet" "sample-subnet-privateB" {
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = false
  availability_zone = "ap-northeast-2b"
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-subnet-privateB"
  }
}

//InternetGateway
resource "aws_internet_gateway" "sample-igw" {
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-igw"
  }
}

//EIP
resource "aws_eip" "sample-eip" {
  vpc = true
}

//NAT Gateway
resource "aws_nat_gateway" "sample-ngw" {
  allocation_id = aws_eip.sample-eip.id
  subnet_id = aws_subnet.sample-subnet-publicA.id

  tags = {
    service = "sample"
    Name = "sample-ngw"
  }
}

//Public RouteTable
resource "aws_route_table" "sample-rt-public" {
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-rt-public"
  }
}

resource "aws_route_table_association" "sample-rt-public-association-1" {
  route_table_id = aws_route_table.sample-rt-public.id
  subnet_id = aws_subnet.sample-subnet-publicA.id
}

resource "aws_route_table_association" "sample-rt-public-association-2" {
  route_table_id = aws_route_table.sample-rt-public.id
  subnet_id = aws_subnet.sample-subnet-publicB.id
}

//Public RouteTable Routing
resource "aws_route" "sample-rt-public-route-1" {
  route_table_id = aws_route_table.sample-rt-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.sample-igw.id
}

//PrivateA RouteTable
resource "aws_route_table" "sample-rt-privateA" {
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-rt-privateA"
  }
}

//PrivateA RouteTableAssociation
resource "aws_route_table_association" "sample-rt-privateA-association-1" {
  route_table_id = aws_route_table.sample-rt-privateA.id
  subnet_id = aws_subnet.sample-subnet-privateA.id
}

//PrivateA RouteTable Routing
resource "aws_route" "sample-rt-privateA-route-1" {
  route_table_id = aws_route_table.sample-rt-privateA.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.sample-ngw.id
}

//PrivateB RouteTable
resource "aws_route_table" "sample-rt-privateB" {
  vpc_id = aws_vpc.sample-vpc.id

  tags = {
    service = "sample"
    Name = "sample-rt-privateB"
  }
}

//PrivateB RouteTableAssociation
resource "aws_route_table_association" "sample-rt-privateB-association-1" {
  route_table_id = aws_route_table.sample-rt-privateB.id
  subnet_id = aws_subnet.sample-subnet-privateB.id
}

//PrivateB RouteTable Routing
resource "aws_route" "sample-rt-privateB-route-1" {
  route_table_id = aws_route_table.sample-rt-privateB.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.sample-ngw.id
}
