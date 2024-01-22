output "k8s_version" {
  value = "${digitalocean_kubernetes_cluster.k8s_cluster.version}"
}