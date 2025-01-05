data "digitalocean_kubernetes_versions" "k8s_cluster" {
  version_prefix = "1.28."
}

resource "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name   = var.k8s_cluster_name
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = data.digitalocean_kubernetes_versions.k8s_cluster.latest_version
  destroy_all_associated_resources = true
  registry_integration = true

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb-amd"
    node_count = 3

  }
}

data "digitalocean_kubernetes_cluster" "k8s_cluster" {
  name = var.k8s_cluster_name
  depends_on = [
    digitalocean_kubernetes_cluster.k8s_cluster
  ]
}

resource "local_file" "kubeconfig" {
  depends_on = [data.digitalocean_kubernetes_cluster.k8s_cluster]
  content    = data.digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].raw_config
  filename   = "${var.config_path}/.kubeconfig"
}