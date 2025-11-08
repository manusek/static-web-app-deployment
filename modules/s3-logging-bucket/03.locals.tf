locals {
  bucket_name = "${var.bucket_name}-logging"

  website_index = "index.html"
  
  website_error = "error.html"

  content_path = "./website-content"
}
