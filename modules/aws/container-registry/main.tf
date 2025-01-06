provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "education_ecr_repo" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}
