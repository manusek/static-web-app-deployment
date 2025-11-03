variable "bucket_name" {
  description = "The globally unique name for the S3 bucket."
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to all resources in this module."
  type        = map(string)
  default     = {} 
}

variable "index_document" {
  description = "The name of the index document for static hosting."
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The name of the error document for 4xx errors."
  type        = string
  default     = "error.html"
}

variable "website_content_path" {
  description = "The local file path containing website content to upload to S3."
  type        = string
  default     = "./website-content" 
}

