resource "aws_ecs_cluster" "example-cluster" {
  name = "example-cluster"
}

resource "aws_ecs_task_definition" "example-task" {
  family                   = "example-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory = "512"
  cpu = "256"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  container_definitions = jsonencode([{
    name = "nginx"
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${aws_ecr_repository.example-ecr-repository.name}:latest"
    portMappings = [{
      containerPort = 8080
      protocol = "tcp"
    }]
    memory = 512
    cpu    = 256
  }])

  runtime_platform {
    cpu_architecture        = "ARM64"
  }
}


resource "aws_ecs_service" "example-service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example-cluster.id
  task_definition = aws_ecs_task_definition.example-task.arn
  desired_count   = 2
  launch_type = "FARGATE"


  network_configuration {
    security_groups = [aws_security_group.example-sg-http.id, aws_default_security_group.default.id]
    subnets         = [aws_subnet.example-subnet-privateA.id, aws_subnet.example-subnet-privateB.id]
    assign_public_ip = false
  }
}

//IAM role
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  inline_policy {
    name = "ecr-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "*"
        }
      ]
    })
  }
}
