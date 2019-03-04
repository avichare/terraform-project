terraform {
  backend "s3" {
    bucket         = "thoughtworks.terraformstate"
    key            = "testenv/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_testenv"
    profile        = "default"
  }
}
