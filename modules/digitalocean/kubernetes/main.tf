locals {
  registry_name_in_k8s_secret = "registry-${var.container_registry_name}"
}

provider "kubernetes" {
  config_path = var.kubeconfig_file_path
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
    ".dockerconfigjson" = var.container_registry_credentials
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