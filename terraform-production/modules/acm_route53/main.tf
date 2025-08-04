# Look up your hosted zone
data "aws_route53_zone" "zone" {
  name         = var.zone_name
  private_zone = false
}

# Request a DNS-validated certificate
resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  tags              = var.tags
}

# Create the DNS validation records
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  zone_id = data.aws_route53_zone.zone.id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Validate the certificate once DNS records exist
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.validation : r.fqdn]
}

# Create the Route 53 alias A record pointing at your ALB (or other target)
resource "aws_route53_record" "alias" {
  zone_id = data.aws_route53_zone.zone.id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.target_dns_name
    zone_id                = var.target_zone_id
    evaluate_target_health = true
  }

  ttl  = 300
}