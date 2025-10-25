terraform {
  source = "../../terraform/route53/"
}


include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

dependency "alb" {
    config_path = "../alb"
}


inputs = {
    domain_name = "brigajani.website"
}
