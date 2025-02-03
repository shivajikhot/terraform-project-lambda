resource "aws_lambda_function" "patient_service" {
  function_name = "patient-service"
  role          = var.lambda_execution_role_arn
  package_type  = "Image"
  image_uri     = var.patient_service_image_uri

  memory_size = 512
  timeout     = 30
  publish     = true

  environment {
    variables = {
      NODE_ENV = "dev"
    }
  }
}

resource "aws_lambda_function" "appointment_service" {
  function_name = "appointment-service"
  role          = var.lambda_execution_role_arn
  package_type  = "Image"
  image_uri     = var.appointment_service_image_uri

  memory_size = 512
  timeout     = 30
  publish     = true

  environment {
    variables = {
      NODE_ENV = "dev"
    }
  }
}
