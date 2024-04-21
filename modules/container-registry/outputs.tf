output "registry_name" {
  value = digitalocean_container_registry.registry.name
}

output "registry_endpoint" {
  value = digitalocean_container_registry.registry.endpoint
}

output "registry_docker_credentials" {
  value     = digitalocean_container_registry_docker_credentials.credentials.docker_credentials
  sensitive = true
}