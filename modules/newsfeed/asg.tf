resource "aws_iam_instance_profile" "backend_instance_profile" {
  name = "${var.role}_instance_profile"
  role = "${var.role}_role"
}

resource "aws_autoscaling_group" "backend_asg" {
  availability_zones   = ["${data.aws_availability_zones.available.names}"]
  name                 = "${var.role}-asg"
  max_size             = "${var.asg_max}"
  min_size             = "${var.asg_min}"
  desired_capacity     = "${var.asg_desired}"
  force_delete         = true
  launch_configuration = "${aws_launch_configuration.backend_lc.name}"
  target_group_arns       = ["${aws_alb_target_group.internal.arn}"]

  tag {
    key                 = "Name"
    value               = "${var.role}-asg"
    propagate_at_launch = "true"
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    app_port = "${var.app_port}"
    role = "${var.role}"
  }
}

resource "aws_launch_configuration" "backend_lc" {
  name                 = "${var.role}-asg-lc"
  image_id             = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type        = "${var.instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.backend_instance_profile.name}"
  security_groups      = ["${aws_security_group.backend_newsfeed_sg.id}"]
  user_data            = "${data.template_file.init.rendered}"
  key_name             = "${var.key_name}"
}
