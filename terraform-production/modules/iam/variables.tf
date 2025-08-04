variable "tags" {
  description = "Map of tags to apply to all IAM resources"
  type        = map(string)
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static/media files"
  type        = string
}
