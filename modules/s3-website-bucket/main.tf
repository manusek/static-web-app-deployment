resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_website_configuration" "website_bucket_static_hosting" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

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

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag         = filemd5("${var.website_content_path}/${var.index_document}") 
}

output "bucket_id" {
  value = aws_s3_bucket.website_bucket.id
}

output "bucket_regional_domain_name" {
    value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}