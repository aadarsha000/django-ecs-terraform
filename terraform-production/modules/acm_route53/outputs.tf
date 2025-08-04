output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "certificate_domain" {
  description = "The validated domain name on the certificate"
  value       = aws_acm_certificate.this.domain_name
}

output "alias_fqdn" {
  description = "The fully-qualified name of the alias record"
  value       = aws_route53_record.alias.fqdn
}