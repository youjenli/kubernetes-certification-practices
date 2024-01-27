locals {
  registry_name_in_k8s_secret = "registry-${var.container_registry_name}"
}

resource "digitalocean_container_registry_docker_credentials" "credentials" {
  registry_name = var.container_registry_name
  depends_on = [
    digitalocean_container_registry.registry
  ]
}

provider "kubernetes" {
  host  = data.digitalocean_kubernetes_cluster.k8s_cluster.endpoint
  token = data.digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(
    data.digitalocean_kubernetes_cluster.k8s_cluster.kube_config[0].cluster_ca_certificate
  )
}

# Save registry credentials to k8s secret
resource "kubernetes_secret_v1" "default_image_pull_secret" {
  metadata {
    namespace = "kube-system"
    name = local.registry_name_in_k8s_secret
    annotations = {
      "digitalocean.com/dosecret-identifier" = local.registry_name_in_k8s_secret
    }
  }

  data = {
    ".dockerconfigjson" = digitalocean_container_registry_docker_credentials.credentials.docker_credentials
  }

  type = "kubernetes.io/dockerconfigjson"
}

# Set default service account image pull secret, so that we don't have to patch it later with CLI
# kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "registry-<your-registry-name>"}]}'
# https://github.com/hashicorp/terraform-provider-kubernetes/issues/302
resource "kubernetes_default_service_account_v1" "default" {
  metadata {
    namespace = "default"
  }
  image_pull_secret {
    name = local.registry_name_in_k8s_secret
  }
}