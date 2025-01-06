variable "kubeconfig_file_path" {
  type        = string
  description = "Kubernetes configuration file path."
}

variable "container_registry_name" {
  type        = string
  description = "Default DigitalOcean container registry name."
  default = "kubernetes-container-registry"
}

variable "container_registry_credentials" {
  type        = string
  description = "Default DigitalOcean container registry credentials."
  sensitive   = true
}