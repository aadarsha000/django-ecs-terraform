# --- S3 Bucket ---
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = {
    Name = "s3-bucket"
  }
}

# --- Public Access Block (secure) ---
resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.main.id
  block_public_acls       = var.block_public_access.block_public_acls
  block_public_policy     = var.block_public_access.block_public_policy
  ignore_public_acls      = var.block_public_access.ignore_public_acls
  restrict_public_buckets = var.block_public_access.restrict_public_buckets
}

# --- Origin Access Control for CloudFront ---
resource "aws_cloudfront_origin_access_control" "s3_access" {
  name                              = "${var.bucket_name}-oac"
  description                       = "Access control for CloudFront to access S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# --- CloudFront CORS Response Headers Policy ---
resource "aws_cloudfront_response_headers_policy" "static_cors" {
  name = "static-cors-policy"
  cors_config {
  access_control_allow_credentials = false
  access_control_max_age_sec       = 86400
  

  access_control_allow_origins {
    items = ["*"]
  }

  access_control_allow_headers {
    items = ["*"]
  }

  access_control_allow_methods {
    items = ["GET", "HEAD"]
  }

  origin_override = true
}

}

# --- CloudFront Distribution ---
resource "aws_cloudfront_distribution" "static" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for static assets"
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.main.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_access.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    response_headers_policy_id = aws_cloudfront_response_headers_policy.static_cors.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "cloudfront-distribution"
  }
}

# --- S3 Bucket Policy to allow CloudFront to read objects ---
resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.main.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.static.arn
          }
        }
      }
    ]
  })
}
