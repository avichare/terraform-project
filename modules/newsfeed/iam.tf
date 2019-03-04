resource "aws_iam_role" "backend_role" {
  name = "${var.role}_role"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy_document.json}"
}

data "aws_iam_policy_document" "assume_role_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "backend_policy" {
  name        = "${var.role}_policy"

  policy = "${data.aws_iam_policy_document.s3access.json}"
}

data "aws_iam_policy_document" "s3access" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
    ]

    resources = ["arn:aws:s3:::thoughtworks-jar-files/*"]
  }
}

resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role       = "${aws_iam_role.backend_role.name}"
  policy_arn = "${aws_iam_policy.backend_policy.arn}"
}
