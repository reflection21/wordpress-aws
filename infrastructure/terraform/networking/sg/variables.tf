variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "deployment_prefix" {
  type        = string
  description = "prefix"
}


variable "add_extra_cidr_blocks" {
  description = "Controls if extra CIDR blocks should be added."
  type        = bool
  default     = false
}

variable "extra_cidr_blocks" {
  type        = list(string)
  description = "Extra CIDR blocks to get access to database."
  default     = []
}