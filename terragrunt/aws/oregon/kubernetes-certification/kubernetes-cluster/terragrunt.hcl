locals {
  # Load the relevant env.hcl file based on where terragrunt was invoked. This works because find_in_parent_folders
  # always works at the context of the child configuration.
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region = local.region_vars.locals.region
}

terraform {
  source = "../../../../../modules/aws/kubernetes-cluster"
}

include "root" {
  path = find_in_parent_folders()
  expose = true
  # Set expose to true, otherwise we could not reference the values in root hcl at inputs section of this hcl.
}

include "csp" {
  path = find_in_parent_folders("csp.hcl")
}

inputs = {
  region = local.region
  k8s_cluster_name = "kubernetes-cluster-playground"
  config_path = "${get_repo_root()}"
}
