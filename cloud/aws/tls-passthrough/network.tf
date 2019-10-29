resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name       = "${var.name_slug}-vpc"
    created-by = "terraform"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name       = "${var.name_slug}-igw"
    created-by = "terraform"
  }
}

resource "aws_subnet" "backend_elb" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.backend_subnet_cidr_1

  tags = {
    Name       = "${var.name_slug}-subnet-elb"
    created-by = "terraform"
  }
}

resource "aws_subnet" "backend_nlb" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.backend_subnet_cidr_2

  tags = {
    Name       = "${var.name_slug}-subnet-nlb"
    created-by = "terraform"
  }
}