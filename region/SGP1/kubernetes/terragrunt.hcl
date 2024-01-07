include "root" {
  path = find_in_parent_folders()
  expose = true
  # Set expose to true, otherwise we could not reference the values in root hcl at inputs section of this hcl.
}

terraform {
  source = "../../../modules/kubernetes"
}

inputs = {
  test = include.root.locals.helloworld
}