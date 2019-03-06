
module "newsfeed_backend" {
  source = "../../modules/newsfeed"

  role        = "newsfeed"
  environment = "test"
  app_port    = 8082
  asg_min     = 1
  asg_max     = 2
  asg_desired = 1
}
