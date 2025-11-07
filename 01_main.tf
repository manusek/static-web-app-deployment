provider "aws" {
  region = local.region
}

provider "aws" {
  alias  = "cloudfront"
  region = "us-east-1"
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
    aws = aws.cloudfront
  }

  project_name = var.project_name
  environment  = var.environment
} 

module "lambda_edge" {
  source = "./modules/lambda-edge"

  providers = {
    aws = aws.cloudfront
  }
}

module "s3_logging" {
  source = "./modules/s3-logging-bucket"

  bucket_name = local.bucket_name_logs
  tags = local.tags
}