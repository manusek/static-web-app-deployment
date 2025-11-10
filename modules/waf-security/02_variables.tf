variable "project_name" {
  type        = string
  description = "The name of the project."
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod)."
}

variable "waf_rules" {
  description = "List of WAF rules."
  type = list(object({
    name       = string
    priority   = number
    metric_suffix = string
    action_type = string

    managed_group_config = optional(object({
      name        = string
      vendor_name = string
    }))
    rate_limit_config = optional(object({
      limit              = number
      aggregate_key_type = string
    }))
  }))
  
   default = [] 
}
