output "k8s_version" {
  value = "${digitalocean_kubernetes_cluster.k8s_cluster.version}"
}

output "docker_credentials_expiration_time" {
  value = digitalocean_container_registry_docker_credentials.registry.credential_expiration_time
}