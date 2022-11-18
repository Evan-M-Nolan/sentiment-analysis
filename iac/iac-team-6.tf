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

  access_key = "AKIASLYTBHMFB5PJCQPA"
  secret_key = "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"
  token = ""
}

variable "accountId" {

}

###################################
#S3 Buckets
###################################

resource "aws_s3_bucket" "static-website" {
  bucket = "static-website-files-514-team666"
}

resource "aws_s3_bucket_policy" "static-website-policy" {
  bucket = aws_s3_bucket.static-website.id
  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "PublicRead",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": [
            "${aws_s3_bucket.static-website.arn}",
            "${aws_s3_bucket.static-website.arn}/*"
          ]
        }
      ]
    }
    EOF
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

resource "aws_s3_bucket_policy" "raw-data-bucket-policy" {
  bucket = aws_s3_bucket.raw-data-bucket.id
  policy = <<EOF
    {
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "AllowPublicRead",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": [
            "${aws_s3_bucket.raw-data-bucket.arn}",
            "${aws_s3_bucket.raw-data-bucket.arn}/*"
          ]
        }
    ]
  }
  EOF
}

resource "aws_s3_bucket" "raw-data-bucket" {
  bucket = "raw-data-bucket-514-team666"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "raw-data-butcket-acl" {
  bucket = aws_s3_bucket.raw-data-bucket.id
  acl = "private"
}


resource "aws_s3_bucket" "processed-data-bucket" {
  bucket = "processed-data-bucket-514-team666"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "processed-data-bucket-policy" {
  bucket = aws_s3_bucket.processed-data-bucket.id
  policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "PublicRead",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": [
            "${aws_s3_bucket.processed-data-bucket.arn}",
            "${aws_s3_bucket.processed-data-bucket.arn}/*"
          ]
        }
      ]
    }
    EOF
}

resource "aws_s3_bucket_acl" "processed-data-butcket-acl" {
  bucket = aws_s3_bucket.processed-data-bucket.id
  acl = "private"
}
resource "aws_s3_bucket_cors_configuration" "processed-data-butcket-cors" {
  bucket = aws_s3_bucket.processed-data-bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

}


###################################
# CloudFront
###################################
resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default"
  description                       = "S3 Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

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

###################################
# Gateway
###################################

resource "aws_api_gateway_rest_api" "api" {
 name = "api-gateway-514-team6"
 description = "Proxy to handle requests to our API"
}

resource "aws_api_gateway_resource" "rekognition_data_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "rekognitionData"
}

resource "aws_api_gateway_resource" "search_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "search"
}

resource "aws_api_gateway_method" "search_getmethod" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.search_resource.id
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "search_getmethod_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.search_resource.id 
  http_method = aws_api_gateway_method.search_getmethod.http_method
  status_code = 200
}

resource "aws_api_gateway_integration" "lambda_info_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.search_resource.id
  http_method             = aws_api_gateway_method.search_getmethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.retreive-rekognition-data.invoke_arn
}

resource "aws_api_gateway_deployment" "gateway_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
      redeployment = sha1(jsonencode([
        aws_api_gateway_resource.rekognition_data_resource.id,
        aws_api_gateway_resource.search_resource.id,
        aws_api_gateway_method.search_getmethod.id,
        aws_api_gateway_integration.lambda_info_integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gateway_stage" {
  deployment_id = aws_api_gateway_deployment.gateway_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "gateway_stage"
}
resource "aws_api_gateway_integration_response" "info_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.search_resource.id
  http_method = aws_api_gateway_method.search_getmethod.http_method
  status_code = aws_api_gateway_method_response.search_getmethod_response.status_code
}

########
# video search api TODO 
########
resource "aws_api_gateway_resource" "video_id_search_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "video_search"
}

resource "aws_api_gateway_method" "video_search" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.video_id_search_resource.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_method_response" "video-id-search_getmethod_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.video_id_search_resource.id 
  http_method = aws_api_gateway_method.video_search.http_method
  status_code = 200
}
resource "aws_api_gateway_integration" "search_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.video_id_search_resource.id
  http_method = "GET"

  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.search-lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.retreive-rekognition-data.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-2:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.search_getmethod.http_method}${aws_api_gateway_resource.search_resource.path}"
}

resource "aws_lambda_permission" "apigw_lambda_video" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.search-lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:us-east-2:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.video_search.http_method}${aws_api_gateway_resource.video_id_search_resource.path}"
}

################################
# Event Bridge with lambda rule
################################
resource "aws_cloudwatch_event_rule" "draw_data" {
  name = "draw_data"
  description = "retry scheduled every 2 min"
  schedule_expression = "rate(2 hours)"
}
resource "aws_cloudwatch_event_target" "data_generator_lambda_target" {
  arn = aws_lambda_function.kickoff-lambda.arn
  rule = aws_cloudwatch_event_rule.draw_data.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.kickoff-lambda.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.draw_data.arn
}

###################################
#Upload files for static website
###################################
resource "aws_s3_bucket_object" "html" {
  for_each = fileset("./../frontend/", "**/*.html")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./../frontend/${each.value}"
  etag   = filemd5("./../frontend/${each.value}")
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "svg" {
  for_each = fileset("./../frontend/", "**/*.svg")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./../frontend/${each.value}"
  etag   = filemd5("./../frontend/${each.value}")
  content_type = "image/svg+xml"
}

resource "aws_s3_bucket_object" "css" {
  for_each = fileset("./../frontend/", "**/*.css")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./../frontend/${each.value}"
  etag   = filemd5("./../frontend/${each.value}")
  content_type = "text/css"
}

resource "aws_s3_bucket_object" "js" {
  for_each = fileset("./../frontend/", "**/*.js")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./../frontend/${each.value}"
  etag   = filemd5("./../frontend/${each.value}")
  content_type = "application/javascript"
}


resource "aws_s3_bucket_object" "images" {
  for_each = fileset("./../frontend/", "**/*.png")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./../frontend/${each.value}"
  etag   = filemd5("./../frontend/${each.value}")
  content_type = "image/png"
}

resource "aws_s3_bucket_object" "json" {
  for_each = fileset("./../frontend/", "**/*.json")

  bucket = aws_s3_bucket.static-website.id
  key    = each.value
  source = "./../frontend/${each.value}"
  etag   = filemd5("./../frontend/${each.value}")
  content_type = "application/json"
}

resource "aws_dynamodb_table" "Hashtag-table-514-team6" {
  name = "Hashtag"
  billing_mode = "PROVISIONED"
  read_capacity = "5"
  write_capacity = "5"
  hash_key = "Id"
  range_key = "searchDate"

  attribute {
    name = "Id"
    type = "S"
  }
  
  attribute {
    name = "searchDate"
    type = "N"
  }
  
}

resource "aws_dynamodb_table" "Video-table-514-team6" {
  name = "Video"
  billing_mode = "PROVISIONED"
  read_capacity = "5"
  write_capacity = "5"
  hash_key = "Id"

  attribute {
    name = "Id"
    type = "S"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  inline_policy {
    name = "access-dynamodb"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["dynamodb:Get*", "dynamodb:UpdateItem", "dynamodb:Query", "dynamodb:Scan"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  inline_policy {
    name = "access-rekognition"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["rekognition:DetectFaces"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }

  inline_policy {
    name = "buckets-access"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["s3:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
  inline_policy {
    name = "sqs-access"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect= "Allow",
          Action= "sqs:*",
          Resource = "*"
        }]
    })
  }
  inline_policy {
    name = "lambda-access"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect= "Allow",
          Action= "lambda:*",
          Resource = "*"
        }]
    })
  }
  inline_policy {
    name = "log-writing-access"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
          {
            Effect = "Allow",
            Action = [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            Resource = "*"
          }
      ]
    })
  }
}

###################
# SQS for lambda
###################
resource "aws_sqs_queue" "youtube_id_queue" {
  name                      = "youtube_id_queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 300
}

##################################
# kick off lambda
##################################

resource "aws_lambda_function" "kickoff-lambda" {
  function_name = "kickoff-lambda"
  role = aws_iam_role.iam_for_lambda.arn
  filename ="kickoff-lambda.zip"
  runtime = "python3.9"
  handler = "kickoff_function.lambda_handler"
}


###################################
#youtube Video Lambdas
###################################

resource "aws_lambda_function" "search-lambda" {
  function_name = "search-youtube-for-ids"
  role = aws_iam_role.iam_for_lambda.arn
  filename = "search-lambda.zip"
  runtime = "python3.9"
  handler = "video_search_function.lambda_handler"
  layers = [aws_lambda_layer_version.request_layer.arn]

  environment {
    variables = {
      sqs_url = aws_sqs_queue.youtube_id_queue.url
    }
  }

}
resource "aws_lambda_layer_version" "request_layer" {
  filename   = "request_layer.zip"
  layer_name = "requests"

  compatible_runtimes = ["python3.9"]
}

resource "aws_lambda_function" "download-lambda" {
  function_name = "download-video-to-s3"
  role = aws_iam_role.iam_for_lambda.arn
  filename = "youtube-lambda.zip"
  runtime = "python3.9"
  memory_size = 3008
  timeout = 300
  handler = "download_lambda.lambda_handler"
  layers = [aws_lambda_layer_version.pytube_layer.arn]

  ephemeral_storage {
    size = 10240 # Min 512 MB and the Max 10240 MB
  }
}
##############################
# SQS to lambda source Mapping I GUESS THIS JUST EXSISTS ALREADY
##############################
# resource "aws_lambda_event_source_mapping" "download_entry" {
#  event_source_arn = aws_sqs_queue.youtube_id_queue.arn
#  function_name    = aws_lambda_function.download-lambda.arn
#  enabled = true
# }

##############################
# Upload layer zip file to s3 bucket
##############################
# Upload an object
resource "aws_s3_bucket_object" "layer_file" {

  bucket = aws_s3_bucket.raw-data-bucket.id

  key    = "cv2-python37-layer.zip"

  acl    = "public-read"  # or can be "public-read"

  source = "./cv2-python37-layer.zip"

  etag = filemd5("./cv2-python37-layer.zip")

}

##############################
# Lambda layers
##############################
resource "aws_lambda_layer_version" "pytube_layer" {
  filename   = "pytube_layer.zip"
  layer_name = "pytube"

  compatible_runtimes = ["python3.9"]
}
# raw-data-bucket-514-team6 
resource "aws_lambda_layer_version" "cv2_layer" {
  s3_bucket  = aws_s3_bucket.raw-data-bucket.id
  layer_name = "cv2"
  s3_key = "cv2-python37-layer.zip"

  compatible_runtimes = ["python3.7"]
}

resource "aws_s3_bucket_notification" "aws-slice-lambda-trigger" {
  bucket = aws_s3_bucket.raw-data-bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.splice-lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [
    aws_lambda_permission.raw-permission
  ]
}

resource "aws_s3_bucket_notification" "aws-lambda-trigger" {
  bucket = aws_s3_bucket.processed-data-bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.store-rekognition-data.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

resource "aws_lambda_permission" "processed-permission" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.store-rekognition-data.function_name
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::${aws_s3_bucket.processed-data-bucket.id}"
}

resource "aws_lambda_permission" "raw-permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.splice-lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw-data-bucket.arn

}




#####################
#Splice Lambda
#####################
resource "aws_lambda_function" "splice-lambda" {
  function_name = "slice-video-to-img"
  role = aws_iam_role.iam_for_lambda.arn
  filename = "splice_lambda.zip"
  runtime = "python3.7"
  memory_size = 3008
  timeout = 300
  handler = "splice_lambda.lambda_handler"
  layers = [aws_lambda_layer_version.cv2_layer.arn]

  ephemeral_storage {
    size = 10240 # Min 512 MB and the Max 10240 MB
  }
}

#####################
#Rekognition Lambdas
#####################

resource "aws_lambda_function" "store-rekognition-data" {
  function_name = "set-rekognition-data"
  role = aws_iam_role.iam_for_lambda.arn
  filename = "rekognition-lambda.zip"
  runtime = "python3.8"
  handler = "rekognition-lambda.lambda_handler"

}

resource "aws_lambda_function" "retreive-rekognition-data" {
  function_name = "get-rekognition-data"
  role = aws_iam_role.iam_for_lambda.arn
  filename = "search-dynamo-lambda.zip"
  runtime = "python3.8"
  handler = "lambda_function.lambda_handler"

  environment {
    variables = {
      dynamodb_hashtag = aws_dynamodb_table.Hashtag-table-514-team6.name
      dynamodb_video = aws_dynamodb_table.Video-table-514-team6.name
    }
  }
}
