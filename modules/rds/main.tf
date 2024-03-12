

locals {
  
environment = var.common_tags.Environment

}



locals {
  is_dev_environment = local.environment == "Dev" || local.environment == "Development" || local.environment == "dev" || local.environment == "development"
  multi_az           = local.is_dev_environment ? false : true
  instance_class      = local.is_dev_environment ? "db.t3.micro" : "db.t3.micro"
}


resource "aws_kms_key" "cmk_key" {
  description             = "CMK for RDS encryption"
  deletion_window_in_days = 7
  tags       = var.common_tags
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = var.rds_subnet_ids  # Replace with your subnet IDs
}

resource "aws_db_instance" "rds_instance" {
  identifier           = var.identifier
  allocated_storage    = var.allocated_storage
  engine               = "mysql"
  #engine_version       = var.engine_version
  instance_class       = local.instance_class
  username             = var.username
  password             = var.password
  multi_az             = local.multi_az
  kms_key_id           = aws_kms_key.cmk_key.arn
  storage_encrypted           = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  skip_final_snapshot  = true
  tags                 = var.common_tags
}

