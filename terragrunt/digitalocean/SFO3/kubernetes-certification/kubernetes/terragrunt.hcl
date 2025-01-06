locals {
  # Load the relevant env.hcl file based on where terragrunt was invoked. This works because find_in_parent_folders
  # always works at the context of the child configuration.
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region = local.region_vars.locals.region
}

terraform {
  source = "../../../../../modules/digitalocean/kubernetes"
}

include "root" {
  path = find_in_parent_folders()
  expose = true
  # Set expose to true, otherwise we could not reference the values in root hcl at inputs section of this hcl.
}

include "csp" {
  path = find_in_parent_folders("csp.hcl")
}

dependency "container_registry" {
  config_path = "../container-registry"
}

dependency "kubernetes_cluster" {
  config_path = "../kubernetes-cluster"
}


inputs = {
  kubeconfig_file_path = dependency.kubernetes_cluster.outputs.kuberconfig_file_path
  container_registry_name = dependency.container_registry.outputs.registry_name
  container_registry_credentials = dependency.container_registry.outputs.registry_docker_credentials
}

# The kubernetes module is extracted from k8s cluster module because it seems that 
# digitalocean terraform module could not find k8s cluster configuration
# after all subsequent applications of the same module.