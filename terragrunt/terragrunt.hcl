locals {
  remote_backend_bucket = try(get_env("REMOTE_BACKEND_BUCKET"))
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket =  local.remote_backend_bucket
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "${local.remote_backend_bucket}-lock"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}