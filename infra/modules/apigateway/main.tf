# 1️⃣ Cognito User Pool (For Authentication)
resource "aws_cognito_user_pool" "pool" {
  name = "serverless-auth-pool"
  auto_verified_attributes = ["email"]  # Automatically verify email
}

# Create a test user
resource "aws_cognito_user" "yt_user" {
  user_pool_id = aws_cognito_user_pool.pool.id
  username     = "testuser"
  password     = "Test@123"
}

# 2️⃣ Cognito User Pool Client (For OAuth Authentication)
resource "aws_cognito_user_pool_client" "client" {
  name         = "serverless-app-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret     = false
  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH"]
  allowed_oauth_flows = ["implicit"]
  allowed_oauth_scopes = ["openid"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls = ["https://${aws_api_gateway_deployment.deployment.invoke_url}"]  # Update frontend URL
}

# Cognito User Pool Domain (For Hosted UI)
resource "aws_cognito_user_pool_domain" "pool_domain" {
  domain       = "serverless-auth-demo"  # Change to a unique domain
  user_pool_id = aws_cognito_user_pool.pool.id
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "hello_api" {
  name        = "hello-world-api"
  description = "API for Hello World Lambda"
}



# Cognito Authorizer for API Gateway
resource "aws_api_gateway_authorizer" "cognito" {
  name          = "CognitoAuthorizer"
  rest_api_id   = aws_api_gateway_rest_api.hello_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [aws_cognito_user_pool.pool.arn]
}

# Create API Gateway Resource for "/hello"
resource "aws_api_gateway_resource" "hello_resource" {
  rest_api_id = aws_api_gateway_rest_api.hello_api.id
  parent_id   = aws_api_gateway_rest_api.hello_api.root_resource_id
  path_part   = "hello"
}

# Create API Gateway Method for GET /hello (Protected by Cognito)
resource "aws_api_gateway_method" "hello_method" {
  rest_api_id   = aws_api_gateway_rest_api.hello_api.id
  resource_id   = aws_api_gateway_resource.hello_resource.id
  http_method   = "ANY"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito.id
}

# Integrate API Gateway with Lambda Function
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.hello_api.id
  resource_id = aws_api_gateway_resource.hello_resource.id
  http_method = aws_api_gateway_method.hello_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.hello_world_invoke_arn
}



# Enable CORS for Browser Access
resource "aws_api_gateway_method_response" "cors" {
  rest_api_id = aws_api_gateway_rest_api.hello_api.id
  resource_id = aws_api_gateway_resource.hello_resource.id
  http_method = aws_api_gateway_method.hello_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# Deploy API Gateway
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.hello_api.id
  stage_name  = "dev"
  depends_on = [
    aws_api_gateway_method.hello_method,
    aws_api_gateway_integration.lambda_integration
  ]
}

# CloudWatch Log Group for API Gateway
resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/api_gw/${aws_api_gateway_rest_api.hello_api.name}"
  retention_in_days = 30
}

#  Lambda Permission to Allow API Gateway to Invoke
resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "helloworld"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hello_api.execution_arn}/*/*"
}
