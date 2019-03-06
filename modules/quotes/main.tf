provider "aws" {
  region = "eu-west-1"
}

data "aws_availability_zones" "available" {}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnet_ids" "default" {
  vpc_id = "${aws_default_vpc.default.id}"
}

data "aws_subnet" "default" {
  count = 3
  id    = "${data.aws_subnet_ids.default.ids[count.index]}"
}


resource "aws_security_group" "backend_quotes_sg" {
  name        = "${var.role}_sg"
  description = "SG for ${var.role} app"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.cidr_blocks}"
  }

  # Accessing on application port from ALB and front-end
  ingress {
    from_port   = "${var.app_port}"
    to_port     = "${var.app_port}"
    protocol    = "tcp"
    cidr_blocks = "${var.cidr_blocks}"
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "backend_alb_quotes" {
  name               = "${var.role}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.backend_quotes_sg.id}"]
  enable_deletion_protection = false
  subnets            = ["${data.aws_subnet.default.*.id}"]

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_alb_target_group" "internal" {
  name                 = "${var.role}-target-group"
  port                 = "${var.app_port}"
  protocol             = "HTTP"
  vpc_id               = "${aws_default_vpc.default.id}"
  deregistration_delay = 60

  health_check {
    interval            = 5
    path                = "/ping"
    protocol            = "HTTP"
    timeout             = 2
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299,403"
  }
}

  resource "aws_lb_listener" "backend" {
  load_balancer_arn = "${aws_lb.backend_alb_quotes.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.internal.arn}"
  }
}

resource "aws_route53_record" "quotes_url" {
  zone_id = "${var.zone_id}"
  name    = "quotes.thoughtworks.local"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.backend_alb_quotes.dns_name}"]
}
