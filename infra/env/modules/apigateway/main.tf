
resource "aws_api_gateway_rest_api" "microservices_api" {
  name        = "MicroservicesAPI"
  description = "API Gateway for Patient and Appointment services"
}

resource "aws_api_gateway_resource" "patient_resource" {
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  parent_id   = aws_api_gateway_rest_api.microservices_api.root_resource_id
  path_part   = "patient"
}

resource "aws_api_gateway_resource" "appointment_resource" {
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  parent_id   = aws_api_gateway_rest_api.microservices_api.root_resource_id
  path_part   = "appointment"
}

resource "aws_api_gateway_method" "patient_method" {
  rest_api_id   = aws_api_gateway_rest_api.microservices_api.id
  resource_id   = aws_api_gateway_resource.patient_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "appointment_method" {
  rest_api_id   = aws_api_gateway_rest_api.microservices_api.id
  resource_id   = aws_api_gateway_resource.appointment_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "patient_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  resource_id = aws_api_gateway_resource.patient_resource.id
  http_method = aws_api_gateway_method.patient_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.patient_lambda_arn
}

resource "aws_api_gateway_integration" "appointment_lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  resource_id = aws_api_gateway_resource.appointment_resource.id
  http_method = aws_api_gateway_method.appointment_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.appointment_lambda_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [aws_api_gateway_integration.patient_lambda_integration, aws_api_gateway_integration.appointment_lambda_integration]
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  stage_name  = "prod"
}
