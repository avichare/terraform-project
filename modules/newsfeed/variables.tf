variable "aws_region" {
  default     = "eu-west-1"
}

#SSH Key pair to login
variable "key_name" {
  default     = "ashish-key"
  description = "Name of AWS key pair"
}

# Route53 zone ID reference
variable "zone_id" {
  default = "XXXXXXXXXXXXX"
  }

# ubuntu-public-image
variable "aws_amis" {
  default = {
    "eu-west-1" = "ami-08b24c07d4426e14d"
  }
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "role" {
  default = "newsfeed"
}

variable "app_port" {
  default = 8082
}

variable "cidr_blocks" {
  default     = ["0.0.0.0/0"]
  description = "It is not recommended to use this default value for Production env"
}

variable "environment" {}

variable "asg_min" {}

variable "asg_max" {}

variable "asg_desired" {}
