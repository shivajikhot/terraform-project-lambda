output "appointment_lambda_arn" {
  value = aws_lambda_function.appointment_service.arn
}

output "function_name" {
  description = "Name of the Lambda function."

  value = aws_lambda_function.appointment_service.function_name
}
output "appointment_invoke_arn" {
  value = aws_lambda_function.appointment_service.invoke_arn
}
