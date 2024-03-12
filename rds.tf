provider "aws" {
  region = "eu-north-1"
}

#PROD RDS
module "rds" {
  source              = "./modules/rds"
  identifier          = "app2"
  allocated_storage   = 20
  username            = var.username
  password            = var.password
  rds_subnet_ids      = var.rds_subnet_ids
  common_tags = var.common_tags_prod
}



resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Security group for allowing SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}

resource "aws_instance" "ec2" {
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
    host        = aws_instance.ec2.public_ip  # Use aws_instance resource instead of self
  }
  
  # provisioner "file" {
  #   source      = "script.sh"
  #   destination = "/tmp/remote_script.sh"
  # }



  tags = var.common_tags_prod
}

output "public_ip" {
  value = aws_instance.ec2.public_ip

}
output "rds_endpoint" {
  value = aws_instance.ec2.public_ip

}
