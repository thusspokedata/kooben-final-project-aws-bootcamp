# Create the Route53 zone if it doesn't exist
resource "aws_route53_zone" "domain_zone" {
  name = var.domain_name

  tags = {
    Name = "hosted-zone-${var.sufix}"
  }
}

# Frontend A record
resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.domain_zone.zone_id
  name    = "kooben.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.frontend_alb_dns_name
    zone_id                = var.frontend_alb_zone_id
    evaluate_target_health = true
  }
}

# Backend A record
resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.domain_zone.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.backend_alb_dns_name
    zone_id                = var.backend_alb_zone_id
    evaluate_target_health = true
  }
} 