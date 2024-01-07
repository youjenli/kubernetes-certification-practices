resource "digitalocean_container_registry" "registry" {
  name                   = "kubernetes-container-registry"
  subscription_tier_slug = "basic"
  region                 = var.region
}