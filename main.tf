provider "aws" {

  region = "eu-central-1"
}

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

module "s3-website-bucket" {
  source      = "./modules/s3-website-bucket"
  bucket_name = var.bucket_name
  tags        = var.tags
}
