resource "aws_route53_zone" "route53_zone" {
  provider = "aws"
  name = "${var.domain}"
}

resource "aws_route53_record" "website_route53_record" {
  provider = "aws"
  zone_id = "${aws_route53_zone.route53_zone.zone_id}"
  name = "${var.domain}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cdn.domain_name}"
    zone_id = "${var.cf_hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_route53_redirect_record" {
  provider = "aws"
  zone_id = "${aws_route53_zone.route53_zone.zone_id}"
  name = "${var.subdomain}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cdn.domain_name}"
    zone_id = "${var.cf_hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "route53_to_cdn" {
  provider = "aws"
  zone_id = "${aws_route53_zone.route53_zone.zone_id}"
  name = "${var.cdnSubDomain}"
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.cdn.domain_name}"
    zone_id = "${var.cf_hosted_zone_id}"
    evaluate_target_health = false
  }
}
