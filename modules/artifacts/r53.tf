
data "aws_route53_zone" "this" {
  name = var.domain_name
}

resource "aws_route53_record" "cloudfront" {
  for_each = aws_cloudfront_distribution.this.aliases
  zone_id  = data.aws_route53_zone.this.zone_id
  name     = each.value
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "cloudfront_aaaa" {
  for_each = aws_cloudfront_distribution.this.aliases
  zone_id  = data.aws_route53_zone.this.zone_id
  name     = each.value
  type     = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}


data "aws_acm_certificate" "this" {
  region   = "us-east-1"
  domain   = "${var.domain_name}"
  statuses = ["ISSUED"]
}