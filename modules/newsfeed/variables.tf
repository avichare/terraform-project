variable "aws_region" {
  default     = "eu-west-1"
}

variable "role" {
  default = "newsfeed"
}

variable "environment" {}

variable "app_port" {
  default = 8082
}

# ubuntu-public-image
variable "aws_amis" {
  default = {
    "eu-west-1" = "ami-08b24c07d4426e14d"
  }
}

variable "ssh_cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "It is not recommended to use this default value for Production env"
}

variable "key_name" {
  default     = "ashish-key"
  description = "Name of AWS key pair"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "asg_min" {}

variable "asg_max" {}

variable "asg_desired" {}
