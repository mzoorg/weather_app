resource "aws_ecr_repository" "app-ecr-repo-tf" {
  name                 = "weatherapp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_authorization_token" "token" {
  registry_id = aws_ecr_repository.app-ecr-repo-tf.registry_id
}

data "aws_ecr_repository" "ecr-data" {
  name = aws_ecr_repository.app-ecr-repo-tf.name
}