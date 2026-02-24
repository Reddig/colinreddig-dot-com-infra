locals {
  s3_origin_id   = "${var.bucket_name}-origin"
  s3_domain_name = "${var.bucket_name}.s3-website-${var.region}.amazonaws.com"
}

resource "aws_cloudfront_distribution" "this" {
  
  enabled = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  origin {
    origin_id                = local.s3_origin_id
    domain_name              = aws_s3_bucket_website_configuration.this.website_endpoint
    # origin_access_control_id = aws_cloudfront_origin_access_control.this.id
    custom_origin_config  {
          origin_protocol_policy = "http-only"
          http_port  = "80"
          https_port = "443"
          origin_ssl_protocols = ["TLSv1.2"]
        }
  }

  aliases = [var.domain_name, "www.${var.domain_name}"]

  default_cache_behavior {
    
    target_origin_id = local.s3_origin_id
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
   viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.this.arn
    ssl_support_method  = "sni-only"
  }

  price_class = "PriceClass_200"

  custom_error_response {
    error_code = 403
    response_code = 200
    response_page_path = "/index.html"
  }
  
  # ordered_cache_behavior {
  #   path_pattern     = "/posts/*"
  #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods   = ["GET", "HEAD"]
  #   target_origin_id = local.s3_origin_id

  #   forwarded_values {
  #     query_string = false

  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl                = 0
  #   default_ttl            = 3600
  #   max_ttl                = 86400
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"
  # }

  #   ordered_cache_behavior {
  #   path_pattern     = "/projects"
  #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods   = ["GET", "HEAD"]
  #   target_origin_id = local.s3_origin_id

  #   forwarded_values {
  #     query_string = false

  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl                = 0
  #   default_ttl            = 3600
  #   max_ttl                = 86400
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"
  # }
}

resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.env}-colinreddig-dot-com-origin-access-control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

