variable "lb_sg" {
  type        = string
  description = "lb sg"
}

variable "public_subnet_id" {
  type = list(string)
  description = "lb subnets"
}

variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "wordpress_server" {
  type = string
  description = "wordpress tg"
}