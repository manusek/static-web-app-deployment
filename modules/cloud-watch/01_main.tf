###### DASHBOARD

resource "aws_cloudwatch_dashboard" "dashboard" {
  dashboard_name = "${var.project_name}-WAF-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      # Widget 1
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            [
              "AWS/WAFV2", "Requests",
              "Rule", var.waf_rule_metrics["AWSManagedRulesCommonRuleSet"],
              "WebACL", var.waf_acl_metric_name,
              "Region", var.region
            ]
          ]
          period = 300
          stat   = "Sum"
          region = var.region
          title  = "Total Requests"
        }
      },

      # Widget 2
      {
        type : "metric",
        x : 0,
        y : 7,
        width : 12,
        height : 6,
        properties : {
          metrics : [
            [
              "AWS/WAFV2", "4xx",
              "WebACL", var.waf_acl_metric_name,
              "Region", var.region
            ],
            [
              "AWS/WAFV2", "5xx",
              "WebACL", var.waf_acl_metric_name,
              "Region", var.region
            ]
          ],
          period : 300,
          stat : "Sum",
          region : var.region
          title : "Client (4xx) and Server (5xx) Errors"
        }
      }
    ]
  })
}


###### SNS CONFIGURATION

resource "aws_sns_topic" "waf_alerts" {
  name = "${var.project_name}-WAF-Alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.waf_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email_endpoint
}


###### CLOUDWATCH ALARM: 5XX

resource "aws_cloudwatch_metric_alarm" "high_5xx_rate" {
  alarm_name          = "${var.project_name}-High-5xx-Rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5xx"
  namespace           = "AWS/WAFV2"
  period              = 300 
  statistic           = "Sum"
  threshold           = 100 

  dimensions = {
    WebACL = var.waf_acl_metric_name
    Region = var.region
  }

  alarm_description = "Alarm triggered if the rate of 5xx errors exceeds the threshold."
  alarm_actions = [aws_sns_topic.waf_alerts.arn]

  ok_actions = [aws_sns_topic.waf_alerts.arn]
}


###### CLOUDWATCH ALARM: 4XX

resource "aws_cloudwatch_metric_alarm" "high_4xx_rate" {
  alarm_name          = "${var.project_name}-High-4xx-Rate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "4xx" 
  namespace           = "AWS/WAFV2"
  period              = 300 
  statistic           = "Sum"
  threshold           = 10

  dimensions = {
    WebACL = var.waf_acl_metric_name
    Region = var.region
  }

  alarm_description = "Alarm triggered if the rate of 4xx errors exceeds the threshold."
  alarm_actions = [aws_sns_topic.waf_alerts.arn]

  ok_actions = [aws_sns_topic.waf_alerts.arn]
}


###### CLOUDWATCH ALARM: WAF BLOCKED REQUESTS

resource "aws_cloudwatch_metric_alarm" "high_waf_blocks" {
  alarm_name          = "${var.project_name}-High-WAF-Blocks"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = 60 
  statistic           = "Sum"
  threshold           = 5 

  dimensions = {
    WebACL = var.waf_acl_metric_name
    Region = var.region
    Rule   = var.waf_rule_metrics["RateLimitRule"] 
  }

  alarm_description = "Alarm triggered if WAF is blocking too many requests via RateLimitRule."
  alarm_actions     = [aws_sns_topic.waf_alerts.arn]
  ok_actions        = [aws_sns_topic.waf_alerts.arn]
}
