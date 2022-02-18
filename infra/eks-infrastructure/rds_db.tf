module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  for_each = toset(["${var.rds-test-name}", "${var.rds-prod-name}"])
  identifier = each.key

  engine               = "mysql"
  engine_version       = "8.0.20"
  family               = "mysql8.0" # DB parameter group
  major_engine_version = "8.0"      # DB option group
  instance_class = "db.t3.small"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false

  name     = "weatherdb"
  username = "mysqluser"
  create_random_password = true
  random_password_length = 12

  port     = 3306

  multi_az               = true
  subnet_ids             = data.aws_subnet_ids.default_subnet_ids.ids
  vpc_security_group_ids = [data.aws_security_group.default_sg.id]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  
  tags = local.tags
}