variable "private_subnet_id" {
  type = string
  description = "private instance id"
}

variable "wordpress_sg" {
  type = string
  description = "private sg"
}

variable "deployment_prefix" {
  type        = string
  description = "prefix"
}

variable "wordpress_profile" {
  type = string
  description = "private profile"
}

