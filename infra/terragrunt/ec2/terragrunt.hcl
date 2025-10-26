terraform {
  source = "../../terraform/ec2/"
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

dependency "iam" {
    config_path = "../iam"
}

inputs = {
  private_subnet_id = dependency.vpc.outputs.private_subnet_id
  wordpress_sg = dependency.sg.outputs.wordpress_sg
  wordpress_profile = dependency.iam.outputs.wordpress_profile
}
