output "alb_id" {
  value = aws_lb.alb.id
}

output "alb_sg" {
  value = alb_sg.id
}

output "name" {
  value = aws_lb_target_group.alb_tg.id
}

