output "hello_world_lambda_arn" {
  value = aws_lambda_function.hello_world.arn
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.hello_world.function_name
}
