################################################################################
# SÃO PAULO (sa-east-1) - VPC Endpoints
################################################################################

# Security Group for Endpoints in São Paulo
resource "aws_security_group" "sp_endpoints_sg" {
  name        = "${var.project_name}-endpoints-sg-sp"
  description = "Allows HTTPS traffic from instances to VPC Endpoints"
  vpc_id      = aws_vpc.sp_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_sp_cidr]
  }

  tags = {
    Name = "${var.project_name}-endpoints-sg-sp"
  }
}

# Interface Endpoints for SSM (required for Session Manager access without Internet)
resource "aws_vpc_endpoint" "sp_ssm" {
  vpc_id              = aws_vpc.sp_vpc.id
  service_name        = "com.amazonaws.sa-east-1.ssm"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.sp_endpoints_sg.id]
  subnet_ids          = [aws_subnet.sp_private_1.id]
  private_dns_enabled = true

  tags = { Name = "${var.project_name}-ssm-endpoint-sp" }
}

resource "aws_vpc_endpoint" "sp_ssmmessages" {
  vpc_id              = aws_vpc.sp_vpc.id
  service_name        = "com.amazonaws.sa-east-1.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.sp_endpoints_sg.id]
  subnet_ids          = [aws_subnet.sp_private_1.id]
  private_dns_enabled = true

  tags = { Name = "${var.project_name}-ssmmessages-endpoint-sp" }
}

resource "aws_vpc_endpoint" "sp_ec2messages" {
  vpc_id              = aws_vpc.sp_vpc.id
  service_name        = "com.amazonaws.sa-east-1.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.sp_endpoints_sg.id]
  subnet_ids          = [aws_subnet.sp_private_1.id]
  private_dns_enabled = true

  tags = { Name = "${var.project_name}-ec2messages-endpoint-sp" }
}

# Gateway Endpoint for S3 (FREE - Allows access to S3 without IGW/NAT)
resource "aws_vpc_endpoint" "sp_s3" {
  vpc_id            = aws_vpc.sp_vpc.id
  service_name      = "com.amazonaws.sa-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.sp_private_rt.id]

  tags = { Name = "${var.project_name}-s3-endpoint-sp" }
}


################################################################################
# OHIO (us-east-2) - VPC Endpoints
################################################################################

# Security Group for Endpoints in Ohio
resource "aws_security_group" "ohio_endpoints_sg" {
  provider    = aws.ohio
  name        = "${var.project_name}-endpoints-sg-ohio"
  description = "Allows HTTPS traffic from instances to VPC Endpoints"
  vpc_id      = aws_vpc.ohio_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_ohio_cidr]
  }

  tags = {
    Name = "${var.project_name}-endpoints-sg-ohio"
  }
}

# Interface Endpoints for SSM (required for Session Manager access without Internet)
resource "aws_vpc_endpoint" "ohio_ssm" {
  provider            = aws.ohio
  vpc_id              = aws_vpc.ohio_vpc.id
  service_name        = "com.amazonaws.us-east-2.ssm"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.ohio_endpoints_sg.id]
  subnet_ids          = [aws_subnet.ohio_private.id]
  private_dns_enabled = true

  tags = { Name = "${var.project_name}-ssm-endpoint-ohio" }
}

resource "aws_vpc_endpoint" "ohio_ssmmessages" {
  provider            = aws.ohio
  vpc_id              = aws_vpc.ohio_vpc.id
  service_name        = "com.amazonaws.us-east-2.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.ohio_endpoints_sg.id]
  subnet_ids          = [aws_subnet.ohio_private.id]
  private_dns_enabled = true

  tags = { Name = "${var.project_name}-ssmmessages-endpoint-ohio" }
}

resource "aws_vpc_endpoint" "ohio_ec2messages" {
  provider            = aws.ohio
  vpc_id              = aws_vpc.ohio_vpc.id
  service_name        = "com.amazonaws.us-east-2.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.ohio_endpoints_sg.id]
  subnet_ids          = [aws_subnet.ohio_private.id]
  private_dns_enabled = true

  tags = { Name = "${var.project_name}-ec2messages-endpoint-ohio" }
}

# Gateway Endpoint for S3 (FREE - Allows access to S3 without IGW/NAT)
resource "aws_vpc_endpoint" "ohio_s3" {
  provider          = aws.ohio
  vpc_id            = aws_vpc.ohio_vpc.id
  service_name      = "com.amazonaws.us-east-2.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.ohio_private_rt.id]

  tags = { Name = "${var.project_name}-s3-endpoint-ohio" }
}
