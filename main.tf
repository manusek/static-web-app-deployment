provider "aws" {
  region = local.region
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
  source      = "./modules/s3-website-bucket"
  
  bucket_name = local.bucket_name
  tags        = local.tags
}

module "name" {
  source      = "./modules/cloudfront-cdn"
  
  project_name = var.project_name
  environment  = var.environment
  s3_bucket_domain_name = module.s3_site.domain_name
  s3_bucket_regional_domain_name = module.s3_site.regional_domain_name
  tags = local.tags
}