terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.19.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "eu-central-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-bucket-5652346"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}