provider "aws" {
  region  = var.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"  # Specify the version constraint here
    }
  }
}

#### RDS ####
module "rds" {
  source              = "./modules/rds"
  is_dev_environment = false
  aws_region          = var.aws_region
  identifier          = var.identifier
  allocated_storage   = var.allocated_storage
  username            = var.username
  password            = var.password
  rds_subnet_ids      = var.rds_subnet_ids
  common_tags         = local.tags
  vpc_id              = var.vpc_id
  rds_security_group   = [aws_security_group.vpc_access_sg.id]
}

##### Security Groups #####
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Security group for allowing SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"  
    cidr_blocks     = ["0.0.0.0/0"]  
  }
  tags = local.tags
}

resource "aws_security_group" "vpc_access_sg" {
  name        = "vpc-access-security-group2"
  description = "Security group allowing access from VPC CIDR"
  vpc_id      = var.vpc_id  # Replace with the ID of your VPC

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups = [aws_security_group.allow_ssh.id]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"  
    cidr_blocks     = ["0.0.0.0/0"]  
  }
  tags = local.tags
}

#### EC2 ####
resource "aws_instance" "ec2" {
  depends_on = [module.rds]
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = "t3.micro"
  key_name      = "ssh-key"
  subnet_id     = var.ec2_subnet_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  user_data     = <<-EOF
                  #!/bin/bash
                  yum update -y
                  yum install -y mysql
                  EOF
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("ssh-key.pem")
    host        = aws_instance.ec2.public_ip 
  }
  tags = local.tags
}


####  dynamically user provisioner ####

resource "null_resource" "create_mysql_users" {
  depends_on = [module.rds,aws_instance.ec2 ]
  for_each = var.mysql_user_password_map

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("ssh-key.pem")
    host        = aws_instance.ec2.public_ip 
  }

  provisioner "remote-exec" {
    inline = [
      "mysql -u ${var.username} -p'${var.password}' -h ${element(split(":", module.rds.rds_endpoint), 0)} -e 'CREATE USER \"${each.key}\"@\"%\" IDENTIFIED BY \"${each.value}\"'",
      "mysql -u ${var.username} -p'${var.password}' -h ${element(split(":", module.rds.rds_endpoint), 0)} -e 'GRANT SELECT,INSERT,UPDATE,DELETE,DROP ON *.* TO \"${each.key}\"@\"%\"'",
      "mysql -u ${var.username} -p'${var.password}' -h ${element(split(":", module.rds.rds_endpoint), 0)} -e 'FLUSH PRIVILEGES'"
    ]
  }
}


output "public_ip" {
  value = aws_instance.ec2.public_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
