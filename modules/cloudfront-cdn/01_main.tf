###### OAC CONFIGURATION

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = local.oac_name
  origin_access_control_origin_type = local.oac_origin_type
  signing_behavior                  = local.signing_behavior
  signing_protocol                  = local.signing_protocol
}


###### CLOUD FRONT DISTRIBUTION

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name              = var.s3_bucket_domain_name
    origin_id                = local.s3_origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  web_acl_id = var.web_acl_id

  enabled             = true
  is_ipv6_enabled     = true
  comment             = local.cf_comment
  default_root_object = local.default_root_object


  ###### CLOUD FRONT CACHE BEHAVIORS

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
 
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    lambda_function_association {
      event_type   = "origin-response"
      lambda_arn   = var.lambda_edge_arn
      include_body = false
    }
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "allow-all"
  }

  # Cache behavior with precedence 1
  ordered_cache_behavior {
    path_pattern     = "/content/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = var.tags

  viewer_certificate {
    cloudfront_default_certificate = true
  }


  ###### ERRORS

   # (4xx)
  custom_error_response {
    error_code         = 400 # Bad Request
    response_code      = 400
    response_page_path = "/error.html"
  }

  custom_error_response {
    error_code         = 403 # Forbidden 
    response_code      = 403
    response_page_path = "/error.html"
  }

  custom_error_response {
    error_code         = 404 # Not Found
    response_code      = 404
    response_page_path = "/error.html"
  }
  
  # (5xx)
  custom_error_response {
    error_code         = 500 # Internal Server Error
    response_code      = 500
    response_page_path = "/error.html"
  }
  
  custom_error_response {
    error_code         = 502 # Bad Gateway
    response_code      = 502
    response_page_path = "/error.html"
  }

  custom_error_response {
    error_code         = 503 # Service Unavailable
    response_code      = 503
    response_page_path = "/error.html"
  }
  
  custom_error_response {
    error_code         = 504 # Gateway Timeout
    response_code      = 504
    response_page_path = "/error.html"
  }


  ###### CLOUD FRONT LOGGING CONFIGURATION

   logging_config {
    bucket          = var.s3_bucket_logging_domain_name
    include_cookies = false
    prefix          = "cloudfront-logs/"
  }
}


