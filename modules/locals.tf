locals {
   #S3 bucket vars
   s3_origin_id                      = "origin-static-web-454"
   

   #OAC configuration vars
   oac_name                          = "default-oac"
   oac_origin_type                   = "s3"
   signing_behavior                  = "always"
   signing_protocol                  = "sigv4"

   default_root_object               = "index.html"


   content_type = "text/html"


    policy_sid = "AllowCloudFrontServicePrincipalReadWrite"

  # Wzorzec dla zasobów S3 (np. dodanie /*)
  # bucket_arn_pattern = "${var.bucket_arn}/*"


} 

