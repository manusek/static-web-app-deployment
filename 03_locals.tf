locals {
  region_eu_central = "eu-central-1"

  region_us_east = "us-east-1"

  tags = {
    Project    = var.project_name
    Enviroment = var.environment
  }

  bucket_name = "helloworld-${var.environment}-s3-euc1"

  bucket_name_logs = "logsbucket-${var.environment}-s3-euc1"

  content_type = "text/html"
}

