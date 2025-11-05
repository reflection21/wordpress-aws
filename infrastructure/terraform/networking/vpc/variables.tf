variable "deployment_prefix" {
  type        = string
  description = "prefix"
}

variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
}

variable "public_subnet_cidr" {
  type        = list(string)
  description = "public subnet cidr"
}

variable "wordpress_subnet_cidr" {
  type        = list(string)
  description = "wordpress subnet cidr"
}

variable "rds_subnet_cidr" {
  type        = list(string)
  description = "rds subnet cidr"
}
