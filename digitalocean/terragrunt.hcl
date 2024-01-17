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