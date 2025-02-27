resource "aws_lb" "alb" {
  name = "alb-${var.sufix}"
  #tfsec:ignore:aws-elb-alb-not-public
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_security_group_id]
  subnets                    = var.public_subnet_ids
  drop_invalid_header_fields = true

  enable_deletion_protection = false

  tags = {
    Name = "alb-${var.sufix}"
  }
}

# ACM Certificate for HTTPS
resource "aws_acm_certificate" "cert" {
  count = var.create_acm_certificate ? 1 : 0

  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "acm-cert-${var.sufix}"
  }
}

# Optional Route53 validation - only if var.validate_certificate is true
locals {
  domain_validation_options = var.create_acm_certificate && var.validate_certificate ? aws_acm_certificate.cert[0].domain_validation_options : []
}

# Get Route53 zone data only if we're validating the certificate
data "aws_route53_zone" "domain" {
  count = var.create_acm_certificate && var.validate_certificate ? 1 : 0
  name  = var.domain_name
}

# Route53 record for domain validation
resource "aws_route53_record" "cert_validation" {
  for_each = var.create_acm_certificate && var.validate_certificate ? {
    for dvo in local.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.validate_certificate ? data.aws_route53_zone.domain[0].zone_id : ""
}

# Certificate validation
resource "aws_acm_certificate_validation" "cert" {
  count = var.create_acm_certificate && var.validate_certificate ? 1 : 0

  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# Target group for the frontend
resource "aws_lb_target_group" "frontend" {
  name     = "fe-tg-${var.sufix}"
  port     = 4000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# Target group for the backend
resource "aws_lb_target_group" "backend" {
  name     = "be-tg-${var.sufix}"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/api/products"
    healthy_threshold   = 2
    unhealthy_threshold = 10
  }
}

# HTTP Listener that redirects to HTTPS
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# HTTPS Listener for secure connections
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn != "" ? var.certificate_arn : (var.create_acm_certificate ? aws_acm_certificate.cert[0].arn : "")

  # Default action routes to frontend
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

# Rule to route backend requests
resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 100

  condition {
    host_header {
      values = ["api.${var.domain_name}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

# Rule to route frontend requests
resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 200

  condition {
    host_header {
      values = [var.domain_name]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
} 