variable "lb_sg" {
  type        = string
  description = "lb sg"
}

variable "public_subnet_id" {
  type        = list(string)
  description = "lb subnets"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "wordpress_server" {
  type        = string
  description = "wordpress tg"
}

variable "validated_certificate" {
  type        = string
  description = "validated certificate"
}

variable "domain_name" {
  type        = string
  description = "dns for site"
}

variable "route53_zone_id" {
  type = string
  description = "zone of route53"
}