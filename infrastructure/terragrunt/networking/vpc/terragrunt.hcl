terraform {
  source = "../../../terraform/networking/vpc/"
}


include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

inputs = {
  vpc_cidr              = "21.0.0.0/16"
  public_subnet_cidr    = ["21.0.1.0/24", "21.0.2.0/24"]
  wordpress_subnet_cidr = ["21.0.11.0/24", "21.0.12.0/24"]
  rds_subnet_cidr       = ["21.0.111.0/24", "21.0.112.0/24"]
}
