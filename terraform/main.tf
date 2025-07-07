# 1. Network Module
module "network" {
  source = "./modules/network"
  vpc_cidr            = "10.0.0.0/16"
  availability_zones  = ["ap-south-1a", "ap-south-1b"]
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs= ["10.0.11.0/24", "10.0.12.0/24"]
}

# 2. Security Groups
module "security_groups" {
  source = "./modules/security-groups"
  vpc_id = module.network.vpc_id
  alb_ingress_cidrs = ["0.0.0.0/0"]
  container_port = 8000
  rds_port = 5432
  alb_http_port = 80
  alb_https_port = 443
}

# 3. ALB
module "alb" {
  source = "./modules/alb"

  vpc_id               = module.network.vpc_id
  public_subnet_ids    = module.network.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id

  container_port       = 8000
  alb_http_port        = 80
  alb_https_port       = 443

  enable_https         =  false 
  domain_name          = "winx22.com"
  health_check_path    = "/"
}

# 4. Postgres
module "postgres" {
  source = "./modules/postgres"

  subnet_ids            = module.network.private_subnet_ids
  vpc_security_group_ids = [module.security_groups.rds_sg_id]

  engine                = "postgres"
  engine_version        = "16"
  instance_class        = "db.t4g.micro"
  allocated_storage     = 20

  db_name               = "django_db"
  username              = "django_user"
  rds_password          = ""          # leave blank to auto-generate
  multi_az              = false
  backup_retention_period = 7
  skip_final_snapshot   = true
  deletion_protection   = false

  name_prefix           = "django-db"
}

# 5. I AM
module "ecs_iam" {
  source = "./modules/iam"
}

# Log groups
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/django"
  retention_in_days = 7
}

# 6. ECS
module "ecs" {
  source = "./modules/ecs"

  cluster_name           = "django-ecs-cluster"
  fargate_cpu            = "512"
  fargate_memory         = "1024"
  execution_role_arn     = module.ecs_iam.execution_role_arn
  task_role_arn          = module.ecs_iam.task_role_arn
  app_image              = "343218218445.dkr.ecr.ap-south-1.amazonaws.com/simple-web-app:latest"
  container_port         = 8000
  private_subnets        = module.network.private_subnet_ids
  security_groups        = [module.security_groups.ecs_sg_id]
  alb_target_group_arn   = module.alb.target_group_arn
  desired_count          = 2
  aws_region             = var.aws_region

  postgres_db            = "django_db"
  postgres_user          = "django_user"
  postgres_password      = module.postgres.db_password
  postgres_host          = module.postgres.db_instance_endpoint
  postgres_port          = "5432"
}

# 7. S3
module "s3" {
  source = "./modules/s3"
  aws_region = var.aws_region
  bucket_name = "your-app-static-bucket"
  block_public_access = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
}