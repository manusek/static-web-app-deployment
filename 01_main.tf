provider "aws" {
  alias = "eu_central"
  region = local.region_eu_central
}

provider "aws" {
  alias  = "us_east"
  region = local.region_us_east
}

###### REMOTE BACKEND CONFIGURATION

terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket = "amzn-s3-bucket-tfstate"
    key    = "static-website/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "terraform-state-lock"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.19.0" 
    }
  }
}


###### MODULES

module "s3_site" {
  source                            = "./modules/s3-website-bucket"
  
  bucket_name                       = local.bucket_name
  tags                              = local.tags
  content_type                      = local.content_type
}

module "cloudfront" {
  source                            = "./modules/cloudfront-cdn"
  
  project_name                      = var.project_name
  environment                       = var.environment
  s3_bucket_domain_name             = module.s3_site.domain_name
  s3_bucket_regional_domain_name    = module.s3_site.regional_domain_name
  tags                              = local.tags
  web_acl_id                        = module.waf.waf_arn
  lambda_edge_arn                   = module.lambda_edge.lambda_edge_arn
  s3_bucket_logging_domain_name     = module.s3_logging.domain_name
}

module "waf" {
  source = "./modules/waf-security"

  providers = {
    aws = aws.us_east
  }
  project_name = var.project_name
  environment  = var.environment
  
  waf_rules = [
  # Rule 1: AWSManagedRulesCommonRuleSet
  {
    name                 = "AWSManagedRulesCommonRuleSet"
    priority             = 1
    action_type          = "NONE"
    metric_suffix        = "common"
    managed_group_config = {
      name        = "AWSManagedRulesCommonRuleSet"
      vendor_name = "AWS"
    }
  },

  # Rule 2: RateLimitRule
  {
    name                 = "RateLimitRule"
    priority             = 2
    action_type          = "BLOCK"
    metric_suffix        = "limit"
    rate_limit_config = {
      limit              = 100
      aggregate_key_type = "IP"
    }
  }
]
} 

module "lambda_edge" {
  source = "./modules/lambda-edge"

  providers = {
    aws = aws.us_east
  }
}

module "s3_logging" {
  source = "./modules/s3-logging-bucket"

  bucket_name = local.bucket_name_logs
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
  tags = local.tags
}

module "cloud_watch" {
  source = "./modules/cloud-watch"

  providers = {
    aws = aws.us_east
  }
  project_name         = var.project_name
  environment          = var.environment
  region               = local.region_us_east
  waf_acl_metric_name  = module.waf.waf_acl_metric_name
  waf_rule_metrics     = module.waf.waf_rule_metrics
  alert_email_endpoint = "kacperkako@gmail.com"
}