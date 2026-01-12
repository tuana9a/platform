resource "aws_s3_bucket" "tuana9a_com" {
  bucket = local.my_domain
}

resource "aws_acm_certificate" "tuana9a_com" {
  domain_name       = local.my_domain
  validation_method = "DNS"

  /*
  creating CloudFront Distribution: operation error CloudFront: CreateDistributionWithTags, https response error StatusCode: 400, RequestID: fd270c25-46c3-4072-84c6-45de58edb4bd,
  InvalidViewerCertificate: The specified SSL certificate doesn't exist, isn't in us-east-1 region, isn't valid, or doesn't include a valid certificate chain.
  */
  region = "us-east-1"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudfront_origin_access_control" "tuana9a_com" {
  name                              = "default-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "tuana9a_com" {
  origin {
    domain_name              = aws_s3_bucket.tuana9a_com.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.tuana9a_com.id
    origin_id                = local.my_domain
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CDN for ${local.my_domain}"
  default_root_object = "index.html"

  aliases = ["${local.my_domain}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.my_domain

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.tuana9a_com.arn
    ssl_support_method  = "sni-only"
  }
}

data "aws_iam_policy_document" "tuana9a_com_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.tuana9a_com.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.tuana9a_com.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "tuana9a_com" {
  bucket = aws_s3_bucket.tuana9a_com.bucket
  policy = data.aws_iam_policy_document.tuana9a_com_bucket_policy.json
}

resource "cloudflare_dns_record" "tuana9a_com" {
  zone_id = data.cloudflare_zone.tuana9a_com.zone_id
  name    = "@"
  ttl     = 3600
  type    = "CNAME"
  comment = "CDN for the tuana9a.com"
  content = aws_cloudfront_distribution.tuana9a_com.domain_name
  proxied = false
}
