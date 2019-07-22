resource "aws_route53_zone" "main" {
  count             = "${var.delegation-set != "" ? 1 : 0}"
  name              = var.domain-name
  delegation_set_id = var.delegation-set.id

  tags = {
    Environment = var.environment
  }
}

resource "aws_route53_zone" "child-zone" {
  count = "${var.delegation-set == "" ? 1 : 0}"
  name  = var.domain-name

  tags = {
    Environment = var.environment
  }
}

locals {
  zone                     = concat(aws_route53_zone.main, aws_route53_zone.child-zone)[0]
  child-delegation-records = concat(aws_route53_record.child-delegation, [""])[0]
}

resource "aws_route53_record" "child-delegation" {
  count = "${var.delegation-set == "" ? 1 : 0}"

  zone_id = var.parent-zone.id
  name    = var.domain-name
  type    = "NS"
  ttl     = "30"

  records = local.zone.name_servers
}
