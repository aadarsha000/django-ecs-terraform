variable "bucket_name" {
  description = "Name of the S3 bucket for static/media assets"
  type        = string
}

variable "block_public_access" {
  description = "Public access block settings for the S3 bucket"
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
}

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
}

variable "tags" {
  description = "Map of tags to apply to all resources"
  type        = map(string)
}

variable "enable_cloudfront" {
  description = "Whether to create a CloudFront distribution"
  type        = bool
  default     = true
}