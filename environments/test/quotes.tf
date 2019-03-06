
module "quotes_backend" {
  source = "../../modules/quotes"

  role        = "quotes"
  environment = "test"
  app_port    = 8083
  asg_min     = 1
  asg_max     = 2
  asg_desired = 1
}
