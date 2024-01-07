resource "digitalocean_vpc" "k8s_vpc" {
  name     = "kubernetes-demo-project-network"
  region   = var.region
  ip_range = "10.106.0.0/20"
}
# Note: vpc could not be a project resource.