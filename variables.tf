variable "aws_region_main" {
  description = "Main AWS region"
  type        = string
}

variable "aws_region_secondary" {
  description = "Secondary AWS region"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
}

variable "vpc_sp_cidr" {
  description = "CIDR block for São Paulo VPC"
  type        = string
}

variable "vpc_ohio_cidr" {
  description = "CIDR block for Ohio VPC"
  type        = string
}

variable "subnet_sp_public_cidr" {
  description = "CIDR for SP public subnet"
  type        = string
}

variable "subnet_sp_private_cidr" {
  description = "CIDR for SP private subnet"
  type        = string
}

variable "subnet_sp_public_2_cidr" {
  description = "CIDR for SP public subnet 2 (ALB HA)"
  type        = string
}

variable "subnet_ohio_private_cidr" {
  description = "CIDR for Ohio private subnet"
  type        = string
}

variable "az_a" {
  description = "First Availability Zone suffix"
  type        = string
  default     = "a"
}

variable "az_b" {
  description = "Second Availability Zone suffix"
  type        = string
  default     = "b"
}

variable "ec2_instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
}
