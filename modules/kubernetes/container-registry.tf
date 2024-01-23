resource "digitalocean_container_registry" "registry" {
  name                   = var.container_registry_name
  subscription_tier_slug = "basic"
  region                 = var.region
}