terraform {
  source = "../../terraform/vpc/"
}


include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

inputs = {
  vpc_cidr = "21.0.0.0/16"  
  public_subnet_cidr              = ["21.0.1.0/24","21.0.2.0/24"]
  private_subnet_cidr              = "21.0.11.0/24"
}
