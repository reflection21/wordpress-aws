terraform {
  source = "../../../terraform/networking/alb/"
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

dependency "vms" {
  config_path = "../../vms/wordpress"
}

dependency "acm" {
  config_path = "../acm"
}

dependency "route53" {
  config_path = "../route53"
}

inputs = {
  lb_sg                 = dependency.sg.outputs.lb_sg
  public_subnet_id      = dependency.vpc.outputs.public_subnet_id
  vpc_id                = dependency.vpc.outputs.vpc_id
  wordpress_server      = dependency.vms.outputs.wordpress_server_id
  validated_certificate = dependency.acm.outputs.validate_cert
  route53_zone_id       = dependency.route53.outputs.route53_zone_id
}
