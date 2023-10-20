provider "aws" {
  #export AWS_ACCESS_KEY_ID=AKIAR3WQHMF3VGEJNUUI
  #export AWS_SECRET_ACCESS_KEY=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
  #  access_key = "AKIAR3WQHMF3VGEJNUUI"
  #  secret_key = "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"
  region = var.region
}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}


resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "172.31.0.0/16"
  tags              = {
    name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet-1 in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}
#
#resource "aws_subnet" "prod_subnet_2" {
#  vpc_id            = data.aws_vpc.prod_vpc.id
#  availability_zone = data.aws_availability_zones.working.names[1]
#  cidr_block        = "172.31.0.0/16"
#  tags              = {
#    name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
#    Account = "Subnet-2 in Account ${data.aws_caller_identity.current.account_id}"
#    Region  = data.aws_region.current.description
#  }
#}

resource "aws_eip" "my_elastic_ip" {
  instance = aws_instance.my_ubuntu.id
}

resource "aws_instance" "my_ubuntu" {
  #  count                  = 1 Count of created instance
  ami                    = "ami-04e601abe3e1a910f"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.terraform-SG.id]
  monitoring             = var.enable_detailed_monitoring

  /* Use Template file for user data instande file() to provide data*/
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Gevorg",
    l_name = "Stepanyan",
    names  = ["Gago", "Samo", "Narek"]
  })

  tags = {
    Name    = "Terraform"
    Owner   = "Gevorg Stepanyan"
    Project = "Terraform Lesson"
    Region  = var.region
  }

  lifecycle {
    /*prevent_destroy = true, Don`t allow to destroy instance
    ignore_changes = ["ami","user_data"] /*Ignore mentioned changes like gitignore)) */
    create_before_destroy = true /* Create new instance before destroy (zero down time)*/
  }

  depends_on = [aws_instance.my_server_db]  /*Will be Create after Database inctance*/
}

resource "aws_instance" "my_server_db" {
  ami                    = "ami-04e601abe3e1a910f"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.terraform-SG.id]

  tags = {
    Name    = "Server Database"
    Owner   = "Gevorg Stepanyan"
    Project = "Terraform Lesson"
  }

  lifecycle {
    create_before_destroy = true /* Create new instance before destroy (zero down time)*/
  }
}

resource "aws_security_group" "terraform-SG" {
  name        = "AWS Terraform SG"
  description = "AWS Terraform SG"

  /* Create Dynamic ingress for many ports*/
  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      description = "TLS from VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform SG"
    Name = "allow_tls_dynamic"
  }
}