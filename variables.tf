variable "tags" {
  description = "A set of tags common to all resources"
  type        = map(string)
  default = {
    Project   = "static-website"
  }
}

variable "bucket_name" {
  description = "The globally unique name for the S3 bucket."
  type        = string
}
