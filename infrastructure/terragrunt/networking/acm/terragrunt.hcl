terraform {
  source = "../../../terraform/networking/acm/"
}


include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

dependency "route53" {
  config_path = "../route53"
}

inputs = {
  route53_zone_id = dependency.route53.outputs.route53_zone_id
}
