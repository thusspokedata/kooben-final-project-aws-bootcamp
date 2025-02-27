output "zone_id" {
  value = aws_route53_zone.domain_zone.zone_id
}

output "name_servers" {
  value = aws_route53_zone.domain_zone.name_servers
}

output "frontend_url" {
  value = var.domain_name
}

output "backend_url" {
  value = "api.${var.domain_name}"
} 