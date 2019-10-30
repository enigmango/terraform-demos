resource "aws_security_group" "frontend_elb" {
  name        = "${var.base_name}-frontend-elb"
  description = "Allow TLS inbound traffic from internet"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # Open the ELB to the internet
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.base_name}-frontend-elb"
  }
}

resource "aws_security_group" "backend_elb_instances" {
  name        = "${var.base_name}-backend-elb-instances"
  description = "Allow TLS inbound traffic from ELB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # Only traffic from the ELB
    security_groups = aws_security_group.frontend_elb.id
  }

  tags = {
    Name = "${var.base_name}-backend-elb"
  }
}

# Instances that receive traffic from an NLB see the IP address of the actual source, not the NLB
# Because of this, SG must be open to 0.0.0.0/0 as if the instance were open to the internet
# ALSO BECAUSE OF THIS, the instances must be in a private subnet (no route to IGW, no public IP) for appropriate security
resource "aws_security_group" "backend_nlb" {
  name        = "${var.base_name}-backend-nlb-instances"
  description = "Allow TLS inbound traffic from NLB with source IP of client"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # Traffic from NLB shows client IP as source
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.base_name}-backend-nlb-instances"
  }
} 