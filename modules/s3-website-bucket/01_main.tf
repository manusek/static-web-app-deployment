#s3 bucket 
resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

#s3 bucket policy configuration
data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = locals.policy_sid
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.website_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}


#s3 bucket static hosting 
resource "aws_s3_bucket_website_configuration" "website_bucket_static_hosting" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = var.index_document
  }

  error_document {
    key = var.error_document
  }
}

#public access block = true
resource "aws_s3_bucket_public_access_block" "website_bucket_public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_object" "website_files" {
  bucket = aws_s3_bucket.website_bucket.id
  key    = var.index_document
  source = "${var.website_content_path}/${var.index_document}" 
  etag   = filemd5("${var.website_content_path}/${var.index_document}") 
  content_type = locals.content_type
}

output "bucket_id" {
  value = aws_s3_bucket.website_bucket.id
}

output "domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}
