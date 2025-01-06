variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "repository_name" {
  type        = string
  description = "ECR repository name"
  default     = "education-repo"
}
