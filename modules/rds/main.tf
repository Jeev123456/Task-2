terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"  # Specify the version constraint here
    }
  }
}



provider "aws" {
  region = var.aws_region

}

locals {
  # Determine whether to enable Multi-AZ deployment based on environment
  multi_az = var.is_dev_environment ? false : true

  # Set the instance class based on environment
  instance_class = var.is_dev_environment ? "db.t3.micro" : "db.m5d.8xlarge"
}

# Create a KMS key for RDS encryption
resource "aws_kms_key" "cmk_key" {
  description             = "CMK for RDS encryption"
  deletion_window_in_days = 7
  tags                    = var.common_tags
}

# Create a subnet group for RDS instance
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.rds_subnet_ids
}

# Provision an RDS instance
resource "aws_db_instance" "rds_instance" {
  identifier           = var.identifier
  allocated_storage    = var.allocated_storage
  engine               = "mysql"
  instance_class       = local.instance_class
  username             = var.username
  password             = var.password
  multi_az             = local.multi_az
  kms_key_id           = aws_kms_key.cmk_key.arn
  storage_encrypted    = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot  = true
  vpc_security_group_ids = var.rds_security_group
  tags                 = var.common_tags
}

