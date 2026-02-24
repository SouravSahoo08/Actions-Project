resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-main-farget"
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "/ecs/dev-app"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = var.alb_sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dev-ecs_sg"
  }
}

resource "aws_ecs_task_definition" "task" {
  family                   = "app"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
  execution_role_arn       = var.iam_task_execution_role

  container_definitions = jsonencode([{
    name  = "app"
    image = var.image
    portMappings = [{
      containerPort = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.logs.name
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

resource "aws_ecs_service" "service" {
  name            = "test-app-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }
}