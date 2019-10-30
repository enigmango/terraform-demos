data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "backend_elb" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = aws_subnet.private.id
  instance_type = "t2.micro"

  tags = {
    Name       = "${var.base_name}-elb-backend-${count.index + 1}"
    created-by = "terraform"
  }
}

resource "aws_instance" "backend_nlb" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = aws_subnet.private.id
  instance_type = "t2.micro"


  tags = {
    Name       = "${var.base_name}-nlb-backend-${count.index + 1}"
    created-by = "terraform"
  }
}

