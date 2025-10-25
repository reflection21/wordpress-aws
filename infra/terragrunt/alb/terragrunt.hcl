terraform {
  source = "../../terraform/alb/"
}

include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true # include variables of parents file
}

dependency "vpc" {
    config_path = "../vpc"
}

dependency "sg" {
    config_path = "../sg"
}

dependency "ec2" {
    config_path = "../ec2"
}

dependency "acm" {
    config_path = "../acm"
}

dependency "route53" {
  config_path = "../route53"
}

inputs = {
  lb_sg = dependency.sg.outputs.lb_sg
  public_subnet_id = dependency.vpc.outputs.public_subnet_id
  vpc_id = dependency.vpc.outputs.vpc_id
  wordpress_server = dependency.ec2.outputs.wordpress_server_id
  validated_certificate = dependency.acm.outputs.validate_cert
  route53_zone_id = dependency.route53.outputs.route53_zone_id
  domain_name = "brigajani.website"
}
