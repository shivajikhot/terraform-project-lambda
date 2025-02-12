# ECR Repository for the microservices
resource "aws_ecr_repository" "hello-world" {
  name = "hello-world"
  tags = {
    Name = "hello-world Repository"
  }
}

