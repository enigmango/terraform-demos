resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name       = "${var.base_name}-vpc"
    created-by = "terraform"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name       = "${var.base_name}-igw"
    created-by = "terraform"
  }
}

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name       = "${var.base_name}-nat-eip"
    created-by = "terraform"
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.id}"

  tags = {
    Name       = "${var.base_name}-nat"
    created-by = "terraform"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 1, 0)

  tags = {
    Name       = "${var.base_name}-public"
    created-by = "terraform"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 1, 1)

  tags = {
    Name       = "${var.base_name}-private"
    created-by = "terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name       = "${var.base_name}-rt-public"
    created-by = "terraform"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name       = "${var.base_name}-rt-private"
    created-by = "terraform"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}