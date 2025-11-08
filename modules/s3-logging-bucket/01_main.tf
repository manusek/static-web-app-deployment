resource "aws_s3_bucket" "logs" {
  bucket = var.bucket_name
  tags = var.tags 
}


###### S3 VERSIONING

resource "aws_s3_bucket_versioning" "enable" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}


###### S3 ENCRYPTION

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.logs.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Use AES256 or aws:kms
    }
    bucket_key_enabled = true
  }
}


###### S3 ACL CONFIGURATION

resource "aws_s3_bucket_acl" "logs_acl" {
  depends_on = [
    aws_s3_bucket_versioning.enable,
    aws_s3_bucket_server_side_encryption_configuration.s3_encryption
  ]
  bucket = aws_s3_bucket.logs.id
  acl    = "private" 
}

resource "aws_s3_bucket_ownership_controls" "logs_ownership" {
  bucket = aws_s3_bucket.logs.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


###### S3 POLICY CONFIGURATION

resource "aws_s3_bucket_policy" "allow_logging" {
  bucket = aws_s3_bucket.logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Statement 1: Permissions for writing logs
      {
        Sid       = "AWSCloudFrontLogsWrite"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = ["s3:PutObject", "s3:PutObjectAcl"] 
        Resource  = "${aws_s3_bucket.logs.arn}/*" 
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      },
      # Statement 2: Permission for reading bucket ACL
      {
        Sid       = "AWSCloudFrontLogsReadACL"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action    = ["s3:GetBucketAcl"]
        Resource  = aws_s3_bucket.logs.arn
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}

                
###### S3 LOGS LIFECYCLE CONFIGURATION

resource "aws_s3_bucket_lifecycle_configuration" "logs_lifecycle" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-logs"
    status = "Enabled"

    expiration {
      days = 30
    }

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}


###### S3 BUCKET PUBLIC ACCES BLOCK

resource "aws_s3_bucket_public_access_block" "acces_block" {
  bucket = aws_s3_bucket.logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}