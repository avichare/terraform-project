module "frontend" {
  source = "../../modules/front-end"

    role        = "front-end"
    environment = "test"
    app_port    = 8081
    asg_min     = 1
    asg_max     = 2
    asg_desired = 1
}
