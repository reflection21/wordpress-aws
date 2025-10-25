terraform {
  source = "../../terraform/route53/"
}


include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

inputs = {
    domain_name = "brigajani.website"
}
