resource "aws_api_gateway_rest_api" "microservices_api" {
  name        = "MicroservicesAPI"
  description = "API Gateway for hello-world  services"
}

# Patient Service API Resource
resource "aws_api_gateway_resource" "hello_world_resource" {
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  parent_id   = aws_api_gateway_rest_api.microservices_api.root_resource_id
  path_part   = "hello-world"
}



# Service Method (POST)
resource "aws_api_gateway_method" "hello_world_method" {
  rest_api_id   = aws_api_gateway_rest_api.microservices_api.id
  resource_id   = aws_api_gateway_resource.hello_world_resource.id
  http_method   = "POST"
  authorization = "NONE"
}


}

#  Lambda Integration
resource "aws_api_gateway_integration" "hello_world_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.microservices_api.id
  resource_id             = aws_api_gateway_resource.hello_world_resource.id
  http_method             = aws_api_gateway_method.hello_world_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.hello_world_lambda_arn}/invocations"
}



# API Gateway Deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on  = [
    aws_api_gateway_integration.hello_world_lambda_integration,

  ]
  rest_api_id = aws_api_gateway_rest_api.microservices_api.id
  stage_name  = "dev"
}

# Lambda Permissions for API Gateway Invocation
resource "aws_lambda_permission" "allow_api_gateway_patient" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.hello-world_lambda_arn
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.microservices_api.execution_arn}/*/*"
}

