variable "identifier" {
  description = "The identifier for the RDS instance"
}

variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance"
}

variable "engine_version" {
  description = "The version of the database engine to use"
}

variable "instance_class" {
  description = "The instance class of the RDS instance"
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
variable "common_tags_dev" {
  type        = map(string)
  description = "Common tags for resources"
  default = {
    "Environment" = "Dev",
    "Project"     = "A3",
    "Owner"       = "Yas",
    // Add more tags as needed
  }
}