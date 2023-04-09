resource "aws_ecs_cluster" "example-cluster" {
  name = "example-cluster"
}

resource "aws_ecs_task_definition" "example-task" {
  family                   = "example-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory = "512"
  cpu = "256"
  container_definitions = jsonencode([{
    name = "nginx"
    image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-northeast-2.amazonaws.com/${aws_ecr_repository.example-ecr-repository.name}"
    portMappings = [{
      containerPort = 8080
      protocol = "tcp"
    }]
  }])

}

resource "aws_ecs_service" "example" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.example-cluster.id
  task_definition = aws_ecs_task_definition.example-task.arn
  desired_count   = 2
  launch_type = "FARGATE"
  network_configuration {
    security_groups = [aws_security_group.example-sg-http.id]
    subnets         = [aws_subnet.example-subnet-privateA.id, aws_subnet.example-subnet-privateB.id]
  }
}


