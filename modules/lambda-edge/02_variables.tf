

variable "region" {
  description = "AWS region for Lambda deployment (must be us-east-1 for Lambda@Edge)"
  type        = string
  default     = "us-east-1"
}