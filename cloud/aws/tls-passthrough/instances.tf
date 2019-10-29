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
  subnet_id     = aws_subnet.backend_elb.id
  instance_type = "t2.micro"

  tags = {
    Name = "ELB backend server ${count.index}"
  }
}

resource "aws_instance" "backend_nlb" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  subnet_id     = aws_subnet.backend_nlb.id
  instance_type = "t2.micro"


  tags = {
    Name = "NLB backend server ${count.index}"
  }
}

