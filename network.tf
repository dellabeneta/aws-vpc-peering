# SÃO PAULO (sa-east-1) - Default Provider

resource "aws_vpc" "sp_vpc" {
  cidr_block           = var.vpc_sp_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc-sp"
  }
}

resource "aws_internet_gateway" "sp_igw" {
  vpc_id = aws_vpc.sp_vpc.id

  tags = {
    Name = "${var.project_name}-igw-sp"
  }
}

resource "aws_subnet" "sp_public" {
  vpc_id                  = aws_vpc.sp_vpc.id
  cidr_block              = var.subnet_sp_public_cidr
  availability_zone       = "${var.aws_region_main}${var.az_a}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-sp-1${var.az_a}"
  }
}

resource "aws_subnet" "sp_private_1" {
  vpc_id            = aws_vpc.sp_vpc.id
  cidr_block        = var.subnet_sp_private_cidr
  availability_zone = "${var.aws_region_main}${var.az_a}"

  tags = {
    Name = "${var.project_name}-private-sp-1${var.az_a}"
  }
}

resource "aws_subnet" "sp_public_2" {
  vpc_id                  = aws_vpc.sp_vpc.id
  cidr_block              = var.subnet_sp_public_2_cidr
  availability_zone       = "${var.aws_region_main}${var.az_b}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-sp-2${var.az_b}"
  }
}

resource "aws_route_table" "sp_public_rt" {
  vpc_id = aws_vpc.sp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sp_igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt-sp"
  }
}

resource "aws_route_table_association" "sp_public_assoc_1" {
  subnet_id      = aws_subnet.sp_public.id
  route_table_id = aws_route_table.sp_public_rt.id
}

resource "aws_route_table_association" "sp_public_assoc_2" {
  subnet_id      = aws_subnet.sp_public_2.id
  route_table_id = aws_route_table.sp_public_rt.id
}

resource "aws_route_table" "sp_private_rt" {
  vpc_id = aws_vpc.sp_vpc.id

  tags = {
    Name = "${var.project_name}-private-rt-sp"
  }
}

resource "aws_route_table_association" "sp_private_assoc" {
  subnet_id      = aws_subnet.sp_private_1.id
  route_table_id = aws_route_table.sp_private_rt.id
}

# OHIO (us-east-2) - Provider: aws.ohio

resource "aws_vpc" "ohio_vpc" {
  provider             = aws.ohio
  cidr_block           = var.vpc_ohio_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc-ohio"
  }
}

resource "aws_subnet" "ohio_private" {
  provider          = aws.ohio
  vpc_id            = aws_vpc.ohio_vpc.id
  cidr_block        = var.subnet_ohio_private_cidr
  availability_zone = "${var.aws_region_secondary}${var.az_a}"

  tags = {
    Name = "${var.project_name}-private-ohio-1${var.az_a}"
  }
}

resource "aws_route_table" "ohio_private_rt" {
  provider = aws.ohio
  vpc_id   = aws_vpc.ohio_vpc.id

  tags = {
    Name = "${var.project_name}-private-rt-ohio"
  }
}

resource "aws_route_table_association" "ohio_private_assoc" {
  provider       = aws.ohio
  subnet_id      = aws_subnet.ohio_private.id
  route_table_id = aws_route_table.ohio_private_rt.id
}
