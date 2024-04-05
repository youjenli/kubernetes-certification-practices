generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.7.0"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    encrypt = true
    bucket =  "martin-do-demo-terraform-backend"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region = "ap-northeast-1"
    dynamodb_table = "martin-do-demo-terraform-backend-lock"
  }
  generate = {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}