output "alb_id" {
  value = aws_lb.alb.id
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.alb_tg.arn
}

