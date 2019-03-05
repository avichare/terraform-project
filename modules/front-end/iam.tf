resource "aws_iam_role" "frontend_role" {
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

resource "aws_iam_policy" "frontend_policy" {
  name        = "${var.role}_policy"

  policy = "${data.aws_iam_policy_document.s3access.json}"
}

data "aws_iam_policy_document" "s3access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*"]
    resources = ["arn:aws:s3:::thoughtworks-jar-files/*",
                 "arn:aws:s3:::thoughtworks-jar-files/"]
  },
  statement {
    effect = "Allow"
    actions = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:eu-west-1:989401080428:parameter/newsfeed_token"]
  }
}



resource "aws_iam_role_policy_attachment" "attach-policy-to-role" {
  role       = "${aws_iam_role.frontend_role.name}"
  policy_arn = "${aws_iam_policy.frontend_policy.arn}"
}
