terraform {
  source = "../../terraform/alb/"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

dependency "vpc" {
    config_path = "../vpc"
}

dependency "sg" {
    config_path = "../sg"
}

dependency "ec2" {
    config_path = "../ec2"
}

inputs = {
  lb_sg = dependency.sg.outputs.lb_sg
  public_subnet_id = dependency.vpc.outputs.public_subnet_id
  vpc_id = dependency.vpc.outputs.vpc_id
  wordpress_server = dependency.ec2.outputs.wordpress_server_id
}
