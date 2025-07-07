variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "block_public_access" {
  description = "Public access settings for the S3 bucket"
  type = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
}

variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
}
