resource "aws_acm_certificate" "tuana9a_com" {
  domain_name       = "tuana9a.com"
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