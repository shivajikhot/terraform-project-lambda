output "patient_lambda_arn" {
  value = aws_lambda_function.patient_service.arn
}

output "appointment_lambda_arn" {
  value = aws_lambda_function.appointment_service.arn
}
