variable "bucket_name" {
  description = "The globally unique name for the S3 bucket."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources in this module."
  type        = map(string)
}
