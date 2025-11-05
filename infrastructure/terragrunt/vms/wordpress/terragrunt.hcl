terraform {
  source = "../../../terraform/vms/wordpress/"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

dependency "sg" {
  config_path = "../../networking/sg"
}

dependency "vpc" {
  config_path = "../../networking/vpc"
}

dependency "iam" {
  config_path = "../../iam"
}

inputs = {
  wordpres_subnet_id = dependency.vpc.outputs.wordpress_subnet_id
  wordpress_sg       = dependency.sg.outputs.wordpress_sg
  wordpress_profile  = dependency.iam.outputs.wordpress_profile
}
