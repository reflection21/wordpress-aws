# Password for db
resource "random_password" "master_password" {
  length           = 32
  min_lower        = 1
  min_numeric      = 3
  min_special      = 3
  min_upper        = 3
  special          = true
  numeric          = true
  upper            = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# SecretsManager Secret
resource "aws_secretsmanager_secret" "rds_passwords" {
  name        = "${var.deployment_prefix}-secret-rds"
  description = "Prod credentials like Database password etc. for ${var.deployment_prefix} environment."
  kms_key_id  = var.kms_key_id
  tags = {
    "Name" = "${var.deployment_prefix}-myrds-db"
    "Type" = "Secrets Manager"
  }
}

resource "aws_secretsmanager_secret_version" "artem_wordpress" {
  secret_id = aws_secretsmanager_secret.rds_passwords.id
  secret_string = jsonencode({
    MYSQL_USER     = var.db_user
    MYSQL_DATABASE = var.db_name
    MYSQL_PASSWORD = random_password.master_password.result
    MYSQL_HOST     = module.rds.db_instance_address
    MYSQL_PORT     = module.rds.db_instance_port
  })
}

# db
module "rds" {
  source                       = "terraform-aws-modules/rds/aws"
  version                      = "6.13.1"
  identifier                   = var.db_instance_identifier
  performance_insights_enabled = var.performance_insights_enabled
  engine                       = var.engine
  engine_version               = var.engine_version
  family                       = var.family
  major_engine_version         = var.major_engine_version

  instance_class        = var.instance_class
  storage_type          = "gp3"
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = true
  kms_key_id            = var.kms_key_id

  db_name  = var.db_name
  username = var.db_user
  password = random_password.master_password.result
  port     = var.port

  multi_az               = var.multi_az
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.mysql.id
  vpc_security_group_ids = [var.mysql_sg]

  skip_final_snapshot              = false
  final_snapshot_identifier_prefix = "${var.db_instance_identifier}-final"

  auto_minor_version_upgrade = true
  maintenance_window         = "Mon:00:00-Mon:03:00"
  backup_retention_period    = 7
  backup_window              = "03:00-06:00"

  copy_tags_to_snapshot     = true
  deletion_protection       = var.deletion_protection
  create_db_option_group    = false
  create_db_parameter_group = true
  parameters = [
    {
      name  = "require_secure_transport"
      value = "0"  # if value "1" need cert for app
    }
  ]
  tags = {
    Name   = var.db_instance_identifier
    Type   = "Relational Database Service"
    Engine = "MySQL"
    Dummy  = "Tag_2"
  }
}


resource "aws_db_subnet_group" "mysql" {
  name       = "rds-subnet-group"
  subnet_ids = var.database_subnet_group
}


# aws_db_instance
