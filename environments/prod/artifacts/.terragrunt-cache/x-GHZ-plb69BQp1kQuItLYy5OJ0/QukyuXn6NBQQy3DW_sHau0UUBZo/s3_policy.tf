resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

# data "aws_iam_policy_document" "origin_bucket_policy" {
#   statement {
#     sid    = "AllowCloudFrontServicePrincipalReadWrite"
#     effect = "Allow"

#     principals {
#       type        = "Service"
#       identifiers = ["cloudfront.amazonaws.com"]
#     }

#     actions = [
#       "s3:GetObject",
#       "s3:PutObject",
#     ]

#     resources = [
#       "${aws_s3_bucket.this.arn}/*",
#     ]

#     condition {
#       test     = "StringEquals"
#       variable = "AWS:SourceArn"
#       values   = [aws_cloudfront_distribution.this.arn]
#     }
#   }
# }

data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      # "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]


  }
}

# resource "aws_s3_bucket_public_access_block" "example" {
#   bucket = aws_s3_bucket.example.id

#   block_public_acls   = false
#   block_public_policy = false
# }

resource "aws_s3_bucket_policy" "b" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}