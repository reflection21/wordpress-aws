variable "deployment_prefix" {
  type        = string
  description = "prefix"
}

variable "domain_name" {
  type        = string
  description = "dns for site"
}

variable "route53_zone_id" {
  type        = string
  description = "route53 zone id"
}
