resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name   = "kubernetes-cluster-playground"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.28.2-do.0"
  vpc_uuid = digitalocean_vpc.k8s_vpc.id
  destroy_all_associated_resources = true
  registry_integration = true

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb-amd"
    node_count = 3

    taint {
      key    = "workloadKind"
      value  = "database"
      effect = "NoSchedule"
    }
  }

  depends_on = [
    digitalocean_container_registry.registry
  ]
}