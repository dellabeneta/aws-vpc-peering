# DATA SOURCES FOR AMIS

data "aws_ami" "amazon_linux_sp" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

data "aws_ami" "amazon_linux_ohio" {
  provider    = aws.ohio
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# SÃO PAULO (sa-east-1) - ALB & App EC2

# Application Load Balancer
resource "aws_lb" "sp_alb" {
  name               = "${var.project_name}-alb-sp"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sp_alb_sg.id]
  subnets            = [aws_subnet.sp_public.id, aws_subnet.sp_public_2.id]

  tags = {
    Name = "${var.project_name}-alb-sp"
  }
}

resource "aws_lb_target_group" "sp_app_tg" {
  name     = "${var.project_name}-tg-sp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.sp_vpc.id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "sp_http_listener" {
  load_balancer_arn = aws_lb.sp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sp_app_tg.arn
  }
}

# EC2 instance in PRIVATE subnet (App)
resource "aws_instance" "sp_app" {
  ami                         = data.aws_ami.amazon_linux_sp.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.sp_private_1.id
  vpc_security_group_ids      = [aws_security_group.sp_app_sg.id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Install Nginx via S3 Gateway Endpoints
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx

              # Simple welcome page to verify the ALB is forwarding traffic
              echo "<h1>App is running in Sao Paulo (sa-east-1)</h1><p>Infrastructure: ALB -> EC2 (Private Subnet) -> VPC Peering.</p>" > /usr/share/nginx/html/index.html

              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name = "${var.project_name}-app-sp"
  }
}

resource "aws_lb_target_group_attachment" "sp_app_attachment" {
  target_group_arn = aws_lb_target_group.sp_app_tg.arn
  target_id        = aws_instance.sp_app.id
  port             = 80
}

# OHIO (us-east-2) - Database EC2

resource "aws_instance" "ohio_db" {
  provider                    = aws.ohio
  ami                         = data.aws_ami.amazon_linux_ohio.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.ohio_private.id
  vpc_security_group_ids      = [aws_security_group.ohio_db_sg.id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # Install MySQL Server for manual configuration later
              dnf install -y mariadb105-server
              systemctl enable mariadb
              systemctl start mariadb

              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              EOF

  tags = {
    Name = "${var.project_name}-db-ohio"
  }
}
