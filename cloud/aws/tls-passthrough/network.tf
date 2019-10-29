resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name         = "TLS passthrough demo VPC"
    "Created by" = "terraform"
  }
}

resource "aws_subnet" "backend_elb" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.backend_subnet_cidr_1

  tags = {
    Name         = "Subnet for ELB"
    "Created by" = "terraform"
  }
}

resource "aws_subnet" "backend_nlb" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.backend_subnet_cidr_2

  tags = {
    Name         = "Subnet for NLB"
    "Created by" = "terraform"
  }
}