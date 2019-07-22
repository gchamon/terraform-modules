variable "cluster-id" {}

variable "service-name" {}

variable "docker-image" {}

variable "aws-region" {}

variable "environment" {}

variable "default-vpc" {}

variable "subnet-ids" {}

variable "service-port" {}

variable "security-group" {}

variable "desired-count" { default = 1 }

variable "cpu" {
  default = 0
}

variable "soft-memory-limit" {
  default = "null"
}

variable "hard-memory-limit" {
  default = 128
}

variable "command" {
  type    = "list"
  default = []
}

variable "volumes" {
  type    = "list"
  default = []
}

variable "environment-variables" {
  type    = "map"
  default = {}
}

variable "slow-start" { default = 0 }

variable "grace-period" { default = 0 }

variable "health-check" {
  type    = "map"
  default = {}
}

variable "default-health-check" {
  type = "map"
  default = {
    enabled             = true
    path                = "/"
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
  }
}

variable "certificate" {
  default = ""
}

variable "certificate-validation" {
  default = ""
}
