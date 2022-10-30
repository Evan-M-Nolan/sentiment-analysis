terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 4.35"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "static-website" {
  bucket = "static-website-files-514-team6-test"
}

resource "aws_s3_bucket_policy" "static-website-policy" {
  bucket = aws_s3_bucket.static-website.id
  policy = file("policy.json")
}

resource "aws_s3_bucket_acl" "static-website-acl" {
  bucket = aws_s3_bucket.static-website.id
  acl = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "static-website-cors" {
  bucket = aws_s3_bucket.static-website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

}

resource "aws_s3_bucket" "raw-data-bucket" {
  bucket = "raw-data-bucket-514-team6-test"
}

resource "aws_s3_bucket_acl" "raw-data-butcket-acl" {
  bucket = aws_s3_bucket.raw-data-bucket.id
  acl = "private"
}

resource "aws_s3_bucket" "processed-data-bucket" {
  bucket = "processed-data-bucket-514-team6-test"
}

resource "aws_s3_bucket_acl" "processed-data-butcket-acl" {
  bucket = aws_s3_bucket.processed-data-bucket.id
  acl = "private"
}

resource "aws_api_gateway_rest_api" "api" {
 name = "api-gateway-514-team6"
 description = "Proxy to handle requests to our API"
}

# # SSL Certificate
# resource "aws_acm_certificate" "ssl_certificate" {
#   provider = aws.acm_provider
#   validation_method = "EMAIL"
#   #validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # Uncomment the validation_record_fqdns line if you do DNS validation instead of Email.
# resource "aws_acm_certificate_validation" "cert_validation" {
#   provider = aws.acm_provider
#   certificate_arn = aws_acm_certificate.ssl_certificate.arn
#   #validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# }

# resource "aws_acm_certificate" "example" {
#   domain_name       = "example.com"
#   validation_method = "EMAIL"
# }

# resource "aws_acm_certificate_validation" "example" {
#   certificate_arn = aws_acm_certificate.example.arn
# }

# # Cloudfront distribution for main s3 site.
# resource "aws_cloudfront_distribution" "s3_distribution" {
#   origin {
#     domain_name = aws_s3_bucket.static-website.bucket_regional_domain_name
#     # origin_access_control_id = aws_cloudfront_origin_access_control.default.id
#     origin_id = "S3-.${aws_s3_bucket.static-website.id}"
#   }
#   # origin {
#   #   domain_name = aws_s3_bucket.www_bucket.website_endpoint
#   #   origin_id = local.s3_origin_id

#   #   custom_origin_config {
#   #     http_port = 80
#   #     https_port = 443
#   #     origin_protocol_policy = "http-only"
#   #     origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
#   #   }
#   # }

#   enabled = true
#   is_ipv6_enabled = true
#   default_root_object = "index.html"

#   aliases = ["www.${aws_s3_bucket.static-website.id}"]

#   custom_error_response {
#     error_caching_min_ttl = 0
#     error_code = 404
#     response_code = 200
#     response_page_path = "/error.html"
#   }

#   default_cache_behavior {
#     allowed_methods = ["GET", "HEAD"]
#     cached_methods = ["GET", "HEAD"]
#     target_origin_id = "S3-www.${aws_s3_bucket.static-website.id}"

#     forwarded_values {
#       query_string = false

#       cookies {
#         forward = "none"
#       }
#     }

#     viewer_protocol_policy = "redirect-to-https"
#     min_ttl = 31536000
#     default_ttl = 31536000
#     max_ttl = 31536000
#     compress = true
#   }

#   restrictions {
#     geo_restriction {
#       restriction_type = "none"
#     }
#   }

#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

# }