variable "region" {
  type        = string
  description = "DigitalOcean data center region."
}

variable "container_registry_name" {
  type        = string
  description = "DigitalOcean container registry name."
  default = "kubernetes-container-registry"
}

variable "config_path" {
  type        = string
  description = "kubectl and docker client config file path."
}