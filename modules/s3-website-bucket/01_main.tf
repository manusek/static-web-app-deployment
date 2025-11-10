resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name
  tags   = var.tags
}

                
###### S3 BUCKET POLICY

data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.website.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}


###### S3 BUCKET PUBLIC ACCES BLOCK

resource "aws_s3_bucket_public_access_block" "acces_block" {
  bucket = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


###### S3 BUCKET STATIC HOSTING

resource "aws_s3_bucket_website_configuration" "static_hosting" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = local.website_index
  }

  error_document {
    key = local.website_error
  }
}

resource "aws_s3_object" "website_files" {
  bucket = aws_s3_bucket.website.id
  key    = local.website_index
  source = "${local.content_path}/${local.website_index}" 
  etag   = filemd5("${local.content_path}/${local.website_index}") 
  content_type = var.content_type
}

resource "aws_s3_object" "website_files_error" {
  bucket = aws_s3_bucket.website.id
  key    = local.website_error
  source = "${local.content_path}/${local.website_error}" 
  etag   = filemd5("${local.content_path}/${local.website_error}") 
  content_type = var.content_type
}