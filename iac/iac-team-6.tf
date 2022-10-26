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
  bucket = "static-website-files-514-team6"
}

resource "aws_s3_bucket_acl" "static-website-acl" {
  bucket = aws_s3_bucket.static-website.id
  acl = "private"
}

resource "aws_s3_bucket" "raw-data-bucket" {
  bucket = "raw-data-bucket-514-team6"
}

resource "aws_s3_bucket_acl" "raw-data-butcket-acl" {
  bucket = aws_s3_bucket.raw-data-bucket.id
  acl = "private"
}

resource "aws_s3_bucket" "processed-data-bucket" {
  bucket = "processed-data-bucket-514-team6"
}

resource "aws_s3_bucket_acl" "processed-data-butcket-acl" {
  bucket = aws_s3_bucket.processed-data-bucket.id
  acl = "private"
}