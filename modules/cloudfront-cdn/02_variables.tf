variable "project_name" {
  type = string
  description = "The name of the project."
}

variable "environment" {
  type = string
  description = "The deployment environment (e.g., dev, staging, prod)."
}

variable "s3_bucket_domain_name" {
  type = string
  default = "value"
  description = "The domain name of the S3 bucket (e.g., example.com)."
}

variable "s3_bucket_regional_domain_name" {
  type = string
  description = "The regional domain name of the S3 bucket, provided as an input from an output of another module."
}

variable "tags" {
  type = map(string)
  description = "A map of tags to apply to the CloudFront distribution."
  }
