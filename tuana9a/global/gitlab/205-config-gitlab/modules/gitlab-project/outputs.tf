output "id" {
  value = gitlab_project.this.id
}

output "name" {
  value = gitlab_project.this.name
}

output "path_with_namespace" {
  value = gitlab_project.this.path_with_namespace
}

output "web_url" {
  value = gitlab_project.this.web_url
}

output "ssh_url_to_repo" {
  value = gitlab_project.this.ssh_url_to_repo
}

output "http_url_to_repo" {
  value = gitlab_project.this.http_url_to_repo
}
