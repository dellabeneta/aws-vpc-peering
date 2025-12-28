################################################################################
# SÃO PAULO (sa-east-1) - Outputs
################################################################################

output "sp_vpc_id" {
  description = "The ID of the VPC in São Paulo"
  value       = aws_vpc.sp_vpc.id
}

output "sp_alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.sp_alb.dns_name
}

output "sp_app_private_ip" {
  description = "The private IP of the App instance in São Paulo"
  value       = aws_instance.sp_app.private_ip
}

################################################################################
# OHIO (us-east-2) - Outputs
################################################################################

output "ohio_vpc_id" {
  description = "The ID of the VPC in Ohio"
  value       = aws_vpc.ohio_vpc.id
}

output "ohio_db_private_ip" {
  description = "The private IP of the Database instance in Ohio"
  value       = aws_instance.ohio_db.private_ip
}

################################################################################
# GLOBAL - Connectivity & Identification
################################################################################

output "vpc_peering_id" {
  description = "The ID of the VPC Peering connection"
  value       = aws_vpc_peering_connection.sp_to_ohio.id
}

output "project_name" {
  description = "Project name tag used for resources"
  value       = var.project_name
}

output "ssm_access_info" {
  description = "Instructions for accessing the instances"
  value       = "Public SSH (22) is CLOSED. Access via AWS Systems Manager (Session Manager) using the IAM Profile: ${aws_iam_instance_profile.ec2_ssm_profile.name}. ALB is the entry point for HTTP."
}
