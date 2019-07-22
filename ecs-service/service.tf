resource "aws_ecs_service" "default" {
  name                               = var.service-name
  cluster                            = var.cluster-id
  task_definition                    = aws_ecs_task_definition.default.arn
  desired_count                      = var.desired-count
  health_check_grace_period_seconds  = var.grace-period
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50

  load_balancer {
    target_group_arn = aws_lb_target_group.default.arn
    container_name   = var.service-name
    container_port   = var.service-port
  }
}

resource "aws_lb_target_group" "default" {
  name       = "${var.environment}-${var.service-name}"
  port       = var.service-port
  protocol   = "HTTP"
  vpc_id     = "${var.default-vpc.id}"
  slow_start = var.slow-start

  health_check {
    enabled             = local.health-check.enabled
    path                = local.health-check.path
    healthy_threshold   = local.health-check.healthy_threshold
    unhealthy_threshold = local.health-check.unhealthy_threshold
    timeout             = local.health-check.timeout
    interval            = local.health-check.interval
    matcher             = local.health-check.matcher
  }
}

locals {
  health-check = merge(var.default-health-check, var.health-check)
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "${var.environment}-${var.service-name}"
  retention_in_days = 1
}

resource "aws_ecs_task_definition" "default" {
  family                   = "${var.service-name}-definition"
  requires_compatibilities = ["EC2"]

  dynamic "volume" {
    for_each = var.volumes
    content {
      name      = volume.value.name
      host_path = volume.value.host_path
    }
  }

  container_definitions = jsonencode(
    yamldecode(
      templatefile(
        "configs/task-definition.yaml.tmpl",
        {
          service-name          = var.service-name
          image                 = var.docker-image
          aws-region            = var.aws-region
          log-group             = aws_cloudwatch_log_group.default.name
          service-port          = var.service-port
          cpu                   = var.cpu
          hard-memory-limit     = var.hard-memory-limit
          soft-memory-limit     = var.soft-memory-limit
          command               = var.command
          volumes               = var.volumes
          environment_variables = var.environment-variables
        }
      )
    )
  )
}
