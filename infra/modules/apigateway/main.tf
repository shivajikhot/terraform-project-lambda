resource "aws_api_gateway_rest_api" "microservices_api" {
  name        = "MicroservicesAPI"
  description = "API Gateway for Patient and Appointment services"
}

# Patient Service API Resource
resource "aws_api_gateway_resource" "patient_resource" {
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  parent_id   = aws_api_gateway_rest_api.microservices_api.root_resource_id
  path_part   = "patient"
}

# Appointment Service API Resource
resource "aws_api_gateway_resource" "appointment_resource" {
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  parent_id   = aws_api_gateway_rest_api.microservices_api.root_resource_id
  path_part   = "appointment"
}

# Patient Service Method (POST)
resource "aws_api_gateway_method" "patient_method" {
  rest_api_id   = aws_api_gateway_rest_api.microservices_api.id
  resource_id   = aws_api_gateway_resource.patient_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Appointment Service Method (POST)
resource "aws_api_gateway_method" "appointment_method" {
  rest_api_id   = aws_api_gateway_rest_api.microservices_api.id
  resource_id   = aws_api_gateway_resource.appointment_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Patient Lambda Integration
resource "aws_api_gateway_integration" "patient_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.microservices_api.id
  resource_id             = aws_api_gateway_resource.patient_resource.id
  http_method             = aws_api_gateway_method.patient_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.patient_lambda_arn}/invocations"
}

# Appointment Lambda Integration
resource "aws_api_gateway_integration" "appointment_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.microservices_api.id
  resource_id             = aws_api_gateway_resource.appointment_resource.id
  http_method             = aws_api_gateway_method.appointment_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.appointment_lambda_arn}/invocations"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [
    aws_api_gateway_integration.patient_lambda_integration,
    aws_api_gateway_integration.appointment_lambda_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  stage_name  = "prod"
}

# Lambda Permissions for API Gateway Invocation
resource "aws_lambda_permission" "allow_api_gateway_patient" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.patient_lambda_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.microservices_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_api_gateway_appointment" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.appointment_lambda_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.microservices_api.execution_arn}/*/*"
}
