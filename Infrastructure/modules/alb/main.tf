resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "alb" {
  name = "ecs-alb"
  load_balancer_type = "application"
  subnets = var.public_subnets
  security_groups = [ aws_security_group.alb_sg ]
}

resource "aws_lb_target_group" "alb_tg" {
  vpc_id = var.vpc_id
  port = 80
  protocol = "HTTP"
  target_type = "ip"
}

resource "aws_lb_listener"  "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}