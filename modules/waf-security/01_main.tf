
###### WAF CONFIGURATION

data "aws_caller_identity" "current" {}

resource "aws_wafv2_web_acl" "waf" {
  name        = local.waf_name
  description = "WAF for ${var.project_name}"
  scope       = "CLOUDFRONT"

  lifecycle {
    create_before_destroy = true
  }

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-waf"
    sampled_requests_enabled   = true
  }

  dynamic "rule" {
    for_each = var.waf_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      ###### ACTIONS 

      dynamic "override_action" {
        for_each = rule.value.action_type == "NONE" ? ["none_config"] : []
        content {
          none {}
        }
      }

      dynamic "action" {
        for_each = rule.value.action_type == "BLOCK" ? ["block_config"] : []
        content {
          block {}
        }
      }


      ###### STATEMENTS

      # Managed Rule Group
      dynamic "statement" {
        for_each = rule.value.managed_group_config != null ? ["managed_group_config"] : []
        content {
          managed_rule_group_statement {
            name        = rule.value.managed_group_config.name 
            vendor_name = rule.value.managed_group_config.vendor_name
          }
        }
      }

      # Rate Based Rule
      dynamic "statement" {
        for_each = rule.value.rate_limit_config != null ? ["rate_limit_config"] : []
        content {
          rate_based_statement {
            limit              = rule.value.rate_limit_config.limit
            aggregate_key_type = rule.value.rate_limit_config.aggregate_key_type
          }
        }
      }
     
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.project_name}-${rule.value.metric_suffix}"
        sampled_requests_enabled   = true
      }
    }
  }  
}


