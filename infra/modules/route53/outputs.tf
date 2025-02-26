output "zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "frontend_url" {
  value = "kooben.${var.domain_name}"
}

output "backend_url" {
  value = "api.${var.domain_name}"
} 