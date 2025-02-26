resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = {
    Name = "route53-zone-${var.sufix}"
  }
}

# Record for Frontend ALB
resource "aws_route53_record" "frontend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.frontend_alb_dns_name
    zone_id               = var.frontend_alb_zone_id
    evaluate_target_health = true
  }
}

# Record for Backend ALB
resource "aws_route53_record" "backend" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.backend_alb_dns_name
    zone_id               = var.backend_alb_zone_id
    evaluate_target_health = true
  }
} 