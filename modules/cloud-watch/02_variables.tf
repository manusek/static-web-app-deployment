###### PROJECT VARIABLES

variable "project_name" {
  type        = string
  description = "The name of the project."
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)."
}

variable "region" {
  description = "Region where the metrics are located (for CloudFront/WAF it is always us-east-1)."
  type        = string
}


###### WAF VARIABLES

variable "waf_acl_metric_name" {
  description = "Main metric name for the Web ACL."
  type        = string
}

variable "waf_rule_metrics" {
  description = "Map of metric names for individual WAF rules."
  type        = map(string)
}

variable "alert_email_endpoint" {
  description = "Email address to SNS"
  type        = string
}
