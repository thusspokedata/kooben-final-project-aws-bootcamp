output "target_group_arn" {
  value = aws_lb_target_group.frontend.arn
}

output "alb_dns_name" {
  value = aws_lb.frontend.dns_name
}

output "alb_zone_id" {
  value = aws_lb.frontend.zone_id
}
