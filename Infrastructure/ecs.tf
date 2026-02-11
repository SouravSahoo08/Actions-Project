resource "aws_ecs_cluster" "main" {
  name = "main-cluster"

  setting {
    name  = "containerInsights" # The only valid value as of now
    value = "enabled"           # Valid values: "enabled", "disabled"
  }
}
