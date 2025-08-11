locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# 1. VPC & Subnets
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  aws_region           = var.aws_region

  tags = local.common_tags
}

# 2. Security Groups
module "security_groups" {
  source            = "./modules/security-groups"
  vpc_id            = module.network.vpc_id
  alb_ingress_cidrs = var.alb_ingress_cidrs
  container_port    = var.container_port
  rds_port          = var.rds_port
  redis_port        = var.redis_port
  flower_port       = var.flower_port
  tags              = local.common_tags
}

# 3. IAM Roles & Policies
module "ecs_iam" {
  source         = "./modules/iam"
  tags           = local.common_tags
  s3_bucket_name = module.s3.s3_bucket_name
}

# 4. Redis (ElastiCache)
module "redis" {
  source             = "./modules/redis"
  subnet_ids         = module.network.private_subnet_ids
  security_group_ids = [module.security_groups.redis_sg_id]
  node_type          = var.redis_node_type
  num_shards         = var.redis_num_shards
  tags               = local.common_tags
}

# 5. PostgreSQL (RDS)
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = var.postgres_password_secret_arn
}
locals {
  db_secret = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)

  # Calculate read replica AZs
  replica_azs = var.distribute_replicas_across_azs ? var.availability_zones : []
}

module "postgres" {
  source                  = "./modules/rds"
  subnet_ids              = module.network.private_subnet_ids
  vpc_security_group_ids  = [module.security_groups.rds_sg_id]
  name_prefix             = "${var.environment}-postgres"
  db_name                 = var.postgres_db
  username                = var.postgres_user
  rds_password            = local.db_secret.password
  instance_class          = var.rds_instance_class
  allocated_storage       = var.rds_allocated_storage
  storage_type            = var.rds_storage_type
  iops                    = var.rds_iops
  multi_az                = true
  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  # Read replica configuration
  create_read_replicas              = var.enable_read_replicas
  read_replica_count               = var.read_replica_count
  read_replica_instance_class      = var.read_replica_instance_class
  read_replica_allocated_storage   = var.read_replica_storage_size
  read_replica_storage_type        = var.read_replica_storage_type
  read_replica_iops               = var.read_replica_iops
  read_replica_availability_zones  = local.replica_azs
  read_replica_multi_az           = false
  read_replica_performance_insights_enabled = true
  read_replica_monitoring_interval = 60


  tags                    = local.common_tags
}

# 6. S3 Bucket for Static & Media
resource "random_id" "bucket_id" {
  byte_length = 4
}

module "s3" {
  source              = "./modules/s3"
  bucket_name         = "${var.environment}-static-${random_id.bucket_id.hex}"
  block_public_access = var.s3_block_public_access
  aws_region          = var.aws_region
  tags                = local.common_tags
}

# 7. Application Load Balancer and ACM_ROUTE
module "alb" {
  source                = "./modules/alb"
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id
  container_port        = var.container_port
  health_check_path     = "/health/"
  enable_https          = true
  domain_name           = "api.winx22.com"
  zone_name             = "winx22.com."
  record_name           = "api"
  tags                  = local.common_tags
}

# 8. ECS: Django Service
module "ecs_django" {
  source                  = "./modules/ecs_django"
  cluster_name            = "${var.environment}-django-cluster"
  fargate_cpu             = var.fargate_cpu
  fargate_memory          = var.fargate_memory
  execution_role_arn      = module.ecs_iam.execution_role_arn
  task_role_arn           = module.ecs_iam.task_role_arn
  app_image               = var.app_image
  container_port          = var.container_port
  private_subnets         = module.network.private_subnet_ids
  security_groups         = [module.security_groups.ecs_sg_id]
  alb_target_group_arn    = module.alb.target_group_arn
  desired_count           = var.ecs_django_desired_count
  min_capacity            = var.ecs_django_min_capacity
  max_capacity            = var.ecs_django_max_capacity
  cpu_target_value        = var.ecs_django_cpu_target
  aws_region              = var.aws_region
  postgres_db             = var.postgres_db
  postgres_user           = var.postgres_user
  postgres_password       = local.db_secret.password
  postgres_host           = module.postgres.db_instance_endpoint
  postgres_port           = module.postgres.db_instance_port

  # read replica endpoints
  postgres_read_hosts     = join(",", module.postgres.read_replica_endpoints)
  postgres_read_count     = module.postgres.read_replica_count

  aws_storage_bucket_name = module.s3.s3_bucket_name
  aws_s3_region_name      = var.aws_region
  aws_s3_custom_domain    = module.s3.cloudfront_domain_name
  celery_broker_url       = "redis://${module.redis.redis_primary_endpoint}:${module.redis.redis_port}/0"
  tags                    = local.common_tags
}

# 9. ECS: Celery Worker
module "ecs_celery" {
  source                  = "./modules/ecs_celery"
  cluster_name            = "${var.environment}-django-cluster"
  cluster_id              = module.ecs_django.cluster_id
  fargate_cpu             = var.fargate_cpu
  fargate_memory          = var.fargate_memory
  execution_role_arn      = module.ecs_iam.execution_role_arn
  task_role_arn           = module.ecs_iam.task_role_arn
  app_image               = var.app_image
  private_subnets         = module.network.private_subnet_ids
  security_groups         = [module.security_groups.ecs_sg_id]
  desired_count           = var.ecs_celery_desired_count
  min_capacity            = var.ecs_celery_min_capacity
  max_capacity            = var.ecs_celery_max_capacity
  memory_target_value     = var.ecs_celery_memory_target
  postgres_db             = var.postgres_db
  postgres_user           = var.postgres_user
  postgres_password       = local.db_secret.password
  postgres_host           = module.postgres.db_instance_endpoint
  postgres_port           = module.postgres.db_instance_port

  # read replica endpoints
  postgres_read_hosts     = join(",", module.postgres.read_replica_endpoints)
  postgres_read_count     = module.postgres.read_replica_count

  aws_region              = var.aws_region
  aws_storage_bucket_name = module.s3.s3_bucket_name
  aws_s3_region_name      = var.aws_region
  aws_s3_custom_domain    = module.s3.cloudfront_domain_name
  celery_broker_url       = "redis://${module.redis.redis_primary_endpoint}:${module.redis.redis_port}/0"
  tags                    = local.common_tags
}

# 10. ECS: Flower Monitoring
module "ecs_flower" {
  source                  = "./modules/ecs_flower"
  cluster_name            = "${var.environment}-django-cluster"
  ecs_cluster_id          = module.ecs_django.cluster_id
  execution_role_arn      = module.ecs_iam.execution_role_arn
  task_role_arn           = module.ecs_iam.task_role_arn
  app_image               = var.app_image
  private_subnets         = module.network.private_subnet_ids
  security_groups         = [module.security_groups.ecs_flower_sg_id]
  alb_target_group_arn    = module.alb.target_group_arn
  aws_region              = var.aws_region
  postgres_db             = var.postgres_db
  postgres_user           = var.postgres_user
  postgres_password       = local.db_secret.password
  postgres_host           = module.postgres.db_instance_endpoint
  postgres_port           = module.postgres.db_instance_port

  # read replica endpoints
  postgres_read_hosts     = join(",", module.postgres.read_replica_endpoints)
  postgres_read_count     = module.postgres.read_replica_count

  aws_storage_bucket_name = module.s3.s3_bucket_name
  aws_s3_region_name      = var.aws_region
  aws_s3_custom_domain    = module.s3.cloudfront_domain_name
  celery_broker_url       = "redis://${module.redis.redis_primary_endpoint}:${module.redis.redis_port}/0"
  tags                    = local.common_tags
}

# 11. CloudWatch Observability
module "cloudwatch" {
  source                     = "./modules/cloudwatch"
  cluster_name               = module.ecs_django.cluster_name
  django_service_name        = module.ecs_django.service_name
  celery_service_name        = module.ecs_celery.service_name
  flower_service_name        = module.ecs_flower.service_name
  rds_instance_identifier    = module.postgres.instance_identifier
  read_replica_count         = module.postgres.read_replica_count
  read_replica_identifiers   = module.postgres.read_replica_identifiers
  redis_replication_group_id = module.redis.replication_group_id
  alarm_actions              = var.alarm_sns_topic_arns
  tags                       = local.common_tags
}