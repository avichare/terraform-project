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

resource "aws_security_group" "frontend_sg" {
  name        = "${var.role}_sg"
  description = "SG for ${var.role} app"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "${var.cidr_blocks}"
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Access to app port from ALB
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

resource "aws_security_group_rule" "egress_frontend_to_newsfeed" {
  type                     = "egress"
  from_port                = "8082"
  to_port                  = "8082"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.frontend_sg.id}"
  #depends_on               = ["${module.newsfeed_backend.aws_security_group.backend_newsfeed_sg}"]
}

resource "aws_security_group_rule" "egress_frontend_to_quotes" {
  type                     = "egress"
  from_port                = "8083"
  to_port                  = "8083"
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.frontend_sg.id}"
  #depends_on               = ["${module.quotes_backend.aws_security_group.backend_quotes_sg}"]
}

resource "aws_lb" "frontend_alb" {
  name               = "${var.role}-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.frontend_sg.id}"]
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

  resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = "${aws_lb.frontend_alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.internal.arn}"
  }
}

resource "aws_lb_listener" "frontend_https" {
load_balancer_arn = "${aws_lb.frontend_alb.arn}"
port              = "443"
protocol          = "HTTPS"

default_action {
  type             = "forward"
  target_group_arn = "${aws_alb_target_group.internal.arn}"
}
}
