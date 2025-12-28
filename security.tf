################################################################################
# SÃO PAULO (sa-east-1) - Security Groups
################################################################################

# Security Group for ALB in São Paulo
resource "aws_security_group" "sp_alb_sg" {
  name        = "${var.project_name}-alb-sg-sp"
  description = "Allow HTTP/HTTPS from anywhere"
  vpc_id      = aws_vpc.sp_vpc.id

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

  tags = {
    Name = "${var.project_name}-alb-sg-sp"
  }
}

# Breaking the cycle by separating the ALB Egress rule
resource "aws_security_group_rule" "sp_alb_egress_to_app" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sp_alb_sg.id
  source_security_group_id = aws_security_group.sp_app_sg.id
}

# Security Group for EC2 Application in São Paulo
resource "aws_security_group" "sp_app_sg" {
  name        = "${var.project_name}-app-sg-sp"
  description = "Allow port 80 from ALB"
  vpc_id      = aws_vpc.sp_vpc.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sp_alb_sg.id]
  }

  # Allow ICMP for debugging peering
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_ohio_cidr]
  }

  # Outbound: Port 3306 to Ohio DB Subnet CIDR
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.subnet_ohio_private_cidr]
  }

  # Egress for SSM and Yum updates (needed for system maintenance)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg-sp"
  }
}

################################################################################
# OHIO (us-east-2) - Security Groups
################################################################################

# Security Group for MySQL Database in Ohio
resource "aws_security_group" "ohio_db_sg" {
  provider    = aws.ohio
  name        = "${var.project_name}-db-sg-ohio"
  description = "Allow MySQL from App Private Subnet"
  vpc_id      = aws_vpc.ohio_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.subnet_sp_private_cidr] # App Subnet CIDR
  }

  # Allow ICMP for debugging peering
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_sp_cidr]
  }

  # Outbound: Restricted as per README (Only allowing 443 for SSM/Maintenance if needed, but keeping it minimal)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-db-sg-ohio"
  }
}
