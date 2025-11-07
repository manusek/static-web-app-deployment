locals {
  region = "eu-central-1"

  tags = {
    Project     = var.project_name
    Enviroment  = var.environment
  }

  bucket_name   = "helloworld-${var.environment}-s3-euc1"

  bucket_name_logs = "logsbucket-${var.environment}-s3-euc1"
} 

