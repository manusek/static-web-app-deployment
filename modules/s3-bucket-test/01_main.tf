resource "aws_s3_bucket" "example" {
  bucket = "my-test-bucket-1234563423"

  tags = {
    Project    = "static-website"
    Environment = "Dev"
  }
}