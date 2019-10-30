# ELB resources
resource "aws_elb" "main" {
  name      = "${var.base_name}-elb"
  subnets   = aws_subnet.public[*].id
  instances = aws_instance.backend_elb[*].id

  listener {
    instance_port     = 443
    instance_protocol = "https"
    lb_port           = 443
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTPS:443/"
    interval            = 30
  }

  cross_zone_load_balancing = true
  idle_timeout              = 400

  tags = {
    Name       = "${var.base_name}-elb"
    created-by = "terraform"
  }
}

# NLB resources
resource "aws_lb" "nlb" {
  name               = "${var.base_name}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = aws_subnet.public[*].id

  tags = {
    Name       = "${var.base_name}-nlb"
    created-by = "terraform"
  }
}

resource "aws_lb_target_group" "nlb" {
  name     = "${var.base_name}-tg-nlb"
  port     = 443
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_target_group_attachment" "nlb" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.nlb.arn
  target_id        = aws_instance.backend_elb[count.index].id
  port             = 443
}

resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb.arn
  }
}