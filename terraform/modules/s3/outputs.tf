output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "s3_bucket_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "cloudfront_distribution_id" {
  description = "The ID of the CloudFront distribution"
  value       = aws_cloudfront_distribution.static.id
}

output "cloudfront_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.static.domain_name
}
