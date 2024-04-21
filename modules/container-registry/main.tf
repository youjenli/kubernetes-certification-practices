resource "digitalocean_container_registry" "registry" {
  name                   = var.container_registry_name
  subscription_tier_slug = "basic"
  region                 = var.region
}

resource "digitalocean_container_registry_docker_credentials" "credentials" {
  registry_name = var.container_registry_name
  depends_on = [
    digitalocean_container_registry.registry
  ]
}