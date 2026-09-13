resource "aws_cloudfront_function" "transform" {
  name    = "${var.env}-colinreddig-dot-com-static-site-transform"
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = file("${path.module}/files/cftransform.js")
}