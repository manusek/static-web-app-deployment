provider "aws" {
  alias  = "cloudfront"
  region = "us-east-1"
}

###### WAF CONFIGURATION

data "aws_caller_identity" "current" {}

resource "aws_wafv2_web_acl" "waf" {
  provider    = aws.cloudfront
  name        = local.waf_name
  description = "WAF for ${var.project_name}"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf"
    sampled_requests_enabled   = true
  }


  ###### WAF RULES

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-common"
      sampled_requests_enabled   = true
    }
  }

   rule {
    name     = "RateLimitRule"
    priority = 2

    action {
      block {} 
    }

    statement {
      rate_based_statement {
        limit              = 100 
        aggregate_key_type = "IP" 
      }
    }

     visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.project_name}-limit"
      sampled_requests_enabled   = true
    }
  }
}
