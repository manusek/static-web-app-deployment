###### RESOURCE VARIABLES

variable "project_name" {
  type = string
  description = "The name of the project."
}

variable "environment" {
  type = string
  description = "The deployment environment (e.g., dev, staging, prod)."
}

variable "tags" {
  type = map(string)
  description = "A map of tags to apply to the CloudFront distribution."
}


###### S3 VARIABLES

variable "s3_bucket_domain_name" {
  type = string
  default = "value"
  description = "The domain name of the S3 bucket (e.g., example.com)."
}

variable "s3_bucket_regional_domain_name" {
  type = string
  description = "The regional domain name of the S3 bucket, provided as an input from an output of another module."
}

variable "s3_bucket_logging_domain_name" {
  type = string
  description = "The domain name of the S3 bucket with logs"
}


###### WAF VARIABLES

variable "web_acl_id" {
  description = "ARN of the WAF Web ACL to associate with CloudFront distribution"
  type        = string
  default     = null
}


###### LAMBDA VARIABLES

variable "lambda_edge_arn" {
  description = "ARN of Lambda@Edge function to attach to CloudFront"
  type        = string
  default     = null
}

