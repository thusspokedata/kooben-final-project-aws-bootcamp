resource "aws_lb" "alb" {
  name               = "alb-${var.sufix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
  drop_invalid_header_fields = true

  enable_deletion_protection = false

  tags = {
    Name = "alb-${var.sufix}"
  }
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
    matcher            = "200"
    path               = "/"
    port               = "traffic-port"
    protocol           = "HTTP"
    timeout            = 5
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

# HTTP Listener that uses host-based routing
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Default action routes to frontend
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

# Rule to route backend requests
resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.http.arn
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
  listener_arn = aws_lb_listener.http.arn
  priority     = 200

  condition {
    host_header {
      values = ["kooben.${var.domain_name}"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
} 