variable "deployment_prefix" {
  type        = string
  description = "prefix"
}

variable "public_subnet_cidr" {
  type = list(string)
  description = "public subnet cidr"
}

variable "private_subnet_cidr" {
  type = string
  description = "private subnet cidr"
}

variable "vpc_cidr" {
  type = string
  description = "vpc cidr"
}