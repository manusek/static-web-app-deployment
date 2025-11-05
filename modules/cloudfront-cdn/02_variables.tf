variable "origin_bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket origin."
  type        = string
}

variable "bucket_id" {
  description = "The ID of the S3 bucket."
  type        = string
}

variable "index_document" {
  description = "The default root object for the distribution."
  type        = string
  default     = "index.html"
}

variable "tags" {
  description = "A map of tags to apply to the CloudFront distribution."
  type        = map(string)
  default     = {}
}
