include "root" {
  path = find_in_parent_folders()
  expose = true
  # Set expose to true, otherwise we could not reference the values in root hcl at inputs section of this hcl.
}

dependency "digitalocean_project" {
  config_path = "../project"

  # Configure mock outputs for the `validate` command that are returned when there are no outputs available 
  # (e.g the module hasn't been applied yet.
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    project_id = "fake-project-id"
  }
}

terraform {
  source = "../../../modules/kubernetes"
}

locals {
  # Load the relevant env.hcl file based on where terragrunt was invoked. This works because find_in_parent_folders
  # always works at the context of the child configuration.
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  region = local.region_vars.locals.region
}

inputs = {
  project_id = dependency.digitalocean_project.outputs.project_id
  region = local.region
}