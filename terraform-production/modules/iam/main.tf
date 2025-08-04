// ECS Task Execution Role: for pulling images and writing logs
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.tags["Environment"]}-ecs-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// ECS Task Role: for app-level permissions (S3, Secrets Manager, etc.)
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.tags["Environment"]}-ecs-task-role"
  assume_role_policy = aws_iam_role.ecs_task_execution_role.assume_role_policy
  tags               = var.tags
}

// Custom S3 Policy: least-privilege to one bucket
resource "aws_iam_policy" "ecs_s3_policy" {
  name        = "${var.tags["Environment"]}-ecs-s3-access"
  description = "Allow ECS tasks to manage objects in the static/media S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = ["arn:aws:s3:::${var.s3_bucket_name}"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = ["arn:aws:s3:::${var.s3_bucket_name}/*"]
      }
    ]
  })
  tags = var.tags
}

// Attach the custom S3 policy to the ECS Task Role
resource "aws_iam_role_policy_attachment" "ecs_s3_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_s3_policy.arn
}
