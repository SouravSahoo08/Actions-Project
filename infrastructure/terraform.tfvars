vpc_cidr_block  = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
ecs_cpu         = "256"
ecs_memory      = "512"
image           = "650251730135.dkr.ecr.us-east-1.amazonaws.com/github-action/my-node-app:latest"
container_port  = 80