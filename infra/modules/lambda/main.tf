resource "aws_lambda_function" "hello_world" {
  function_name = "helloworld"
  role          = var.lambda_execution_role_arn
  package_type  = "Image"
  image_uri     = var.hello_world_image_uri

  memory_size = 512
  timeout     = 30
  publish     = true

  environment {
    variables = {
      NODE_ENV = "dev"
    }
  }
}

