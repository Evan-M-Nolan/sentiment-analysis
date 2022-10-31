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

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default"
  description                       = "S3 Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

###################################
# CloudFront
###################################
resource "aws_cloudfront_distribution" "static-website" {
  origin {
    domain_name = aws_s3_bucket.static-website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id   = aws_s3_bucket.static-website.bucket
  }
  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.static-website.bucket
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 5 * 60
    max_ttl     = 60 * 60

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

#Upload files for static website
resource "aws_s3_bucket_object" "html" {
  for_each = fileset("./", "**/*.html")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./${each.value}"
  etag   = filemd5("./${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "svg" {
  for_each = fileset("./", "**/*.svg")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./${each.value}"
  etag   = filemd5("./${each.value}")
  content_type = "image/svg+xml"
}

resource "aws_s3_bucket_object" "css" {
  for_each = fileset("./", "**/*.css")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./${each.value}"
  etag   = filemd5("./${each.value}")
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "js" {
  for_each = fileset("./", "**/*.js")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./${each.value}"
  etag   = filemd5("./${each.value}")
  content_type = "application/javascript"
}


resource "aws_s3_bucket_object" "images" {
  for_each = fileset("./", "**/*.png")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./${each.value}"
  etag   = filemd5("./${each.value}")
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "json" {
  for_each = fileset("./", "**/*.json")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./${each.value}"
  etag   = filemd5("./${each.value}")
  content_type = "application/json"
}