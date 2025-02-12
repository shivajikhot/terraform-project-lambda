# Outputs for ECR Repository URIs
output "hello-world_repo_uri" {
  value = aws_ecr_repository.hello-world.repository_url
}
