resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.owner_name}_vpc"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.owner_name}_igw"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.owner_name}_vpc__public_subnet"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route  {
    cidr_block = var.cidr_allowing_all
    gateway_id = aws_internet_gateway.igw.id
    
  }
  tags = {
    Name = "${var.owner_name}_vpc_public_routetable"
  }
}
resource "aws_route_table_association" "public_route_table_assosciations" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}