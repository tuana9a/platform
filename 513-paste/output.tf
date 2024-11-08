output "uri" {
  value = google_cloud_run_v2_service.paste.uri
}

output "cmd" {
  value = "dig -t txt ${cloudflare_record.paste.hostname}"
}