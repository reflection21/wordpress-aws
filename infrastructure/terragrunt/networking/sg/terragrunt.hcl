terraform {
  source = "../../../terraform/networking/sg/"
}


include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

dependency "vpc" {
  config_path = "../vpc"
}


inputs = {
  vpc_id                = dependency.vpc.outputs.vpc_id
  add_extra_cidr_blocks = false
  extra_cidr_blocks     = [] # Example: ["10.242.2.0/24", "10.246.110.0/24"]
}
