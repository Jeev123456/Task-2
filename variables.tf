variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "identifier" {
  description = "The identifier for the RDS instance"
}

variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance"
}


variable "username" {
  description = "The username for the master user"
}

variable "password" {
  description = "The password for the master user"
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed."
}

variable "ec2_subnet_id" {
  description = "Subnet ID for EC2 instances."
  type        = string
}

variable "rds_subnet_ids" {
  description = "Subnet IDs for RDS instance."
  type        = list(string)
}

variable "common_tags_prod" {
  type        = map(string)
  description = "Common tags for resources"
  default = {
    "Environment" = "Prod",
    "Project"     = "A2",
    "Owner"       = "Yas",
    // Add more tags as needed
  }
}
variable "common_tags" {
  type        = map(string)
  description = "Common tags for resources"
  default = {
    "Terraform" = "True",
    "Project"     = "A3",
    "Owner"       = "Yas",
    // Add more tags as needed
  }
}

variable "environment" {
  description = "environment"
  type        = string
  default     = "Dev"
}

variable "mysql_user_password_map" {
  type = map(string)
  default = {
    #"user1" = "password1"
  }
}
