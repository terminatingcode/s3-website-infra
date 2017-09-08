variable "domain" {}
variable "subdomain" {}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.domain}"
  acl    = "public-read"
policy = <<EOF
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_main",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.domain}/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket" "website_redirect_bucket" {
  bucket = "${var.subdomain}"
  acl    = "public-read"
policy = <<EOF
{
  "Id": "bucket_policy_site",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "bucket_policy_site_main",
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.subdomain}/*",
      "Principal": "*"
    }
  ]
}
EOF

  website {
    redirect_all_requests_to = "http://${var.domain}"
  }
}
