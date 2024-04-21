variable "region" {
  type        = string
  description = "DigitalOcean data center region."
}

variable "k8s_cluster_name" {
  type        = string
  description = "Kubernetes cluster name."
  default = "kubernetes-cluster-playground"
}

variable "config_path" {
  type        = string
  description = "kubectl and docker client config file path."
}