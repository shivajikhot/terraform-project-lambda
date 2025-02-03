module "iam" {
  source = "../../modules/iam"
}

module "lambda" {
  source                        = "../../modules/lambda"
  patient_service_image_uri     = var.patient_service_image_uri
  appointment_service_image_uri = var.appointment_service_image_uri
  patient_db_url                = var.patient_db_url
  appointment_db_url            = var.appointment_db_url
  lambda_execution_role_arn     = module.iam.lambda_execution_role_arn
}

module "apigateway" {
  source                     = "../../modules/apigateway"
  patient_lambda_arn         = module.lambda.patient_lambda_arn
  appointment_lambda_arn     = module.lambda.appointment_lambda_arn
}
