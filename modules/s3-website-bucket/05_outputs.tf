output "bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}

output "regional_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}