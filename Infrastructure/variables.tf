variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "ecs_cpu" {
  type = number
}

variable "ecs_memory" {
  type = number
}

variable "image" {
  type = string
}

variable "container_port" {
  type = number
}
