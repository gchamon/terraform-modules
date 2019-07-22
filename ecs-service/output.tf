output "ecs-service" {
  value = aws_ecs_service.default
}

output "target-group" {
  value = aws_lb_target_group.default
}

output "log-group" {
  value = aws_cloudwatch_log_group.default
}

output "task-definition" {
  value = aws_ecs_task_definition.default
}
