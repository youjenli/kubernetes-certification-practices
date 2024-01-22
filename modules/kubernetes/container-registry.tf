resource "digitalocean_container_registry" "registry" {
  name                   = var.container_registry_name
  subscription_tier_slug = "basic"
  region                 = var.region
}

resource "digitalocean_container_registry_docker_credentials" "registry" {
  registry_name = var.container_registry_name
  depends_on = [
    digitalocean_container_registry.registry
  ]
}

resource "local_file" "docker_credentials" {
  depends_on = [digitalocean_container_registry_docker_credentials.registry]
  content    = digitalocean_container_registry_docker_credentials.registry.docker_credentials
  filename   = "${var.config_path}/docker.json"
}