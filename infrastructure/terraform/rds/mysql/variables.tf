variable "deployment_prefix" {
  description = "deployment-prefix"
  type        = string
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
}

variable "db_name" {
  description = "database name"
  type        = string
}

variable "db_user" {
  description = "database user"
  type        = string
}

variable "db_instance_identifier" {
  description = "rds name"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}
variable "family" {
  description = "The family of the DB parameter group"
  type        = string
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
}
variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true"
  type        = bool
  default     = true
}

variable "mysql_sg" {
  type        = string
  description = "sg for db"
}

variable "port" {
  type    = number
  default = 3306
}

variable "database_subnet_group" {
  description = "db subnet group"
  type        = list(string)
}

