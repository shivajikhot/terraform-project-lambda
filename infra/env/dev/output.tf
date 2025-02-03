output "function_name" {
  description = "Base URL of the deployed API Gateway"
  value       = module.lambda.function_name
}
output "base_url" {
  description = "Base URL of the deployed API Gateway"
  value       = module.apigateway.base_url
}
