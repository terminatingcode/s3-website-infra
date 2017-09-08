variable "cdnSubDomain" {}
variable "cf_hosted_zone_id" {}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment="cloudfront id"
}

resource "aws_cloudfront_distribution" "cdn" {
  provider = "aws"
  depends_on = ["aws_s3_bucket.website_bucket"]
  origin {
    domain_name = "${aws_s3_bucket.website_bucket.bucket_domain_name}"
    origin_id = "website_bucket_origin"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }
  enabled = true
  default_root_object = "index.html"
  aliases = ["${var.domain}", "${var.subdomain}"]
  price_class = "PriceClass_200"
  retain_on_delete = true
  default_cache_behavior {
    allowed_methods = [ "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT" ]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "website_bucket_origin"
    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "allow-all"
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
