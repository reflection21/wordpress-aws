terraform {
  source = "../../../terraform/rds/mysql/"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true # include variables of parents file
}

dependency "vpc" {
  config_path = "../../networking/vpc"
}

dependency "kms" {
  config_path = "../../kms"
}

dependency "sg" {
  config_path = "../../networking/sg"
}

inputs = {
  db_instance_identifier = "wordpress-rds"
  engine                 = "mysql"
  engine_version         = "8.4.4"
  family                 = "mysql8.4"     # DB parameter group
  major_engine_version   = "8.0"          # DB option group  
  instance_class         = "db.t4g.micro" # arm
  allocated_storage      = 30
  max_allocated_storage  = 50
  kms_key_id             = dependency.kms.outputs.kms_deployment_key_arn
  db_name                = "wordpressdb"
  db_user                = "wordpressuser"
  database_subnet_group  = dependency.vpc.outputs.rds_subnet_id
  mysql_sg               = dependency.sg.outputs.mysql_sg
  deletion_protection    = false
  extra_cidr_blocks      = [] # Example: ["10.242.2.0/24", "10.246.110.0/24"]
}
