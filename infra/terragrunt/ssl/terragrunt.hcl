terraform {
  source = "../../terraform/ssl/"
}


include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

dependency "route53" {
  config_path = "../route53"
}

inputs = {
    domain_name = "brigajani.website"
    route53_zone_id = dependency.outputs.route53.route53_zone_id
}

