# doctl kubernetes cluster create <your-cluster-name> --tag do-tutorial --auto-upgrade=true --node-pool "name=mypool;count=2;auto-scale=true;min-nodes=1;max-nodes=3;tag=do-tutorial"

# 10.104.0.0/20

resource "digitalocean_vpc" "k8s_vpc" {
  name     = "kubernetes-demo-project-network"
  region   = var.region
  ip_range = "10.106.0.0/20"
}
# Note: vpc could not be a project resource.

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name   = "kubernetes-cluster-demo"
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.28.2-do.0"
  vpc_uuid = digitalocean_vpc.k8s_vpc.id
  destroy_all_associated_resources = true

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
}

resource "digitalocean_project_resources" "module_resources" {
  project = var.project_id
  resources = [
    digitalocean_kubernetes_cluster.k8s_cluster.urn
  ]
}