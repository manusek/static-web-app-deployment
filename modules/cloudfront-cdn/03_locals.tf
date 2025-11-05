locals {
  cf_comment             = "CDN for ${var.project_name} (${var.environment})"

  oac_name               = "${var.project_name}_oac"
  oac_origin_type        = "s3"
  signing_behavior       = "always"
  signing_protocol       = "sigv4"

  default_root_object    = "index.html"

  s3_origin_id           = "${var.project_name}_id"
}