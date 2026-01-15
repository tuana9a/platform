resource "helm_release" "loki" {
  name             = "loki"
  namespace        = "loki-system"
  create_namespace = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  version    = "6.10.2"

  values = [templatefile("./values.yaml", {
    s3_access_key_id                 = aws_iam_access_key.loki_k8s_cobi_tuana9a.id,
    s3_secret_access_key_uri_encoded = urlencode(aws_iam_access_key.loki_k8s_cobi_tuana9a.secret),
    s3_bucket_names                  = "${aws_s3_bucket.loki_chunks_k8s_cobi_tuana9a.bucket},${aws_s3_bucket.loki_ruler_k8s_cobi_tuana9a.bucket}"
    s3_chunks_bucket_name            = aws_s3_bucket.loki_chunks_k8s_cobi_tuana9a.bucket
    s3_ruler_bucket_name             = aws_s3_bucket.loki_ruler_k8s_cobi_tuana9a.bucket
    s3_region                        = "ap-southeast-1",
  })]
}
