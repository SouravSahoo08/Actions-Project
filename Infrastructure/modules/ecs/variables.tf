variable "vpc_id" {
  type = string
}

variable "alb_sg" {
  type = list(string)
}

variable "cpu" {
  type = string
}

variable "memory" {
  type = string
}

variable "iam_task_execution_role" {
  type = string
}

variable "image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "private_subnets" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}