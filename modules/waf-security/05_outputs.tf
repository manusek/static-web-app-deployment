output "waf_arn" {
  value       = aws_wafv2_web_acl.waf.arn
  description = "ARN of the WAF Web ACL"
}

output "waf_acl_metric_name" {
  description = "The main metric name for the Web ACL."
  value       = aws_wafv2_web_acl.waf.visibility_config[0].metric_name
}

output "waf_rule_metrics" {
  description = "A map of metric names for individual WAF rules."
  value = {
    for rule in var.waf_rules : 
    rule.name => "${var.project_name}-${rule.metric_suffix}"
  }
}