resource "aws_cognito_user_pool" "pool" {
  name = "serverless-auth-pool"
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "serverless-app-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret       = false
  explicit_auth_flows   = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_CUSTOM_AUTH"]
  allowed_oauth_flows   = ["implicit"]
  allowed_oauth_scopes  = ["openid"]
  allowed_oauth_flows_user_pool_client = true
  callback_urls = ["${aws_apigatewayv2_api.lambda_api.api_endpoint}/serverless_lambda_stage/hello"] # Update with actual frontend URL if applicable
}

resource "aws_cognito_user_pool" "pool" {
  name = "serverless-auth-pool"

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  auto_verified_attributes = ["email"]  # Automatically verify email
}


resource "aws_apigatewayv2_authorizer" "cognito_auth" {
  api_id          = aws_apigatewayv2_api.lambda.id
  name            = "CognitoAuth"
  authorizer_type = "JWT"
  identity_sources = ["$request.header.Authorization"]

  jwt_configuration {
    audience = [aws_cognito_user_pool_client.client.id]
    issuer   = "https://cognito-idp.us-west-1.amazonaws.com/${aws_cognito_user_pool.pool.id}"
  }
}


resource "aws_apigatewayv2_api" "lambda" {
  name          = "serverless_lambda_gw"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["GET", "POST", "OPTIONS"]
    allow_headers = ["Authorization"]
  }
}

resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.lambda.id

  name        = "serverless_lambda_stage"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}

resource "aws_apigatewayv2_integration" "hello_world" {
  api_id = aws_apigatewayv2_api.lambda.id

  integration_uri    = var.hello_world_invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "hello_world" {
  api_id    = aws_apigatewayv2_api.lambda.id
  route_key = "GET /hello"
  target    = "integrations/${aws_apigatewayv2_integration.hello_world.id}"
  
  authorization_type = "JWT"
  authorizer_id      = aws_apigatewayv2_authorizer.cognito_auth.id
}


resource "aws_cloudwatch_log_group" "api_gw" {
  name = "/aws/api_gw/${aws_apigatewayv2_api.lambda.name}"

  retention_in_days = 30
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "helloworld"
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.lambda.execution_arn}/*/*"
}
