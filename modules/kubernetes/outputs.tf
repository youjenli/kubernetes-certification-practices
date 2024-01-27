output "k8s_version" {
  value = "${digitalocean_kubernetes_cluster.k8s_cluster.version}"
}

output "registry_credentials_secret_name" {
  value = local.registry_name_in_k8s_secret
}