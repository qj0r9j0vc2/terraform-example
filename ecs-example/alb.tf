resource "aws_lb" "example-alb" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example-sg-http.id, aws_default_security_group.default.id]
  subnets            = [aws_subnet.example-subnet-publicA.id, aws_subnet.example-subnet-publicB.id]

  enable_deletion_protection = false
}


resource "aws_alb_target_group" "example-tg" {
  name        = "example-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.example-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "example-listener" {
  load_balancer_arn = aws_lb.example-alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.example-tg.arn
  }
}

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.example-cluster.name}/${aws_ecs_service.example-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 80
  }
}

resource "aws_iam_policy" "ssl_certificate_policy" {
  name = "ssl_certificate_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "AllowManageSSLCertificates"
        Effect = "Allow"
        Action = [
          "iam:CreateServerCertificate",
          "iam:ListServerCertificates",
          "iam:DeleteServerCertificate",
          "iam:GetServerCertificate"
        ]
        Resource = "*"
      }
    ]
  })
}
