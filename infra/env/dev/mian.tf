module "iam" {
  source = "../../modules/iam"
}

module "lambda" {
  source                        = "../../modules/lambda"
  patient_service_image_uri     = var.patient_service_image_uri
  appointment_service_image_uri = var.appointment_service_image_uri
  lambda_execution_role_arn     = module.iam.lambda_execution_role_arn
}

module "apigateway" {
  source                     = "../../modules/apigateway"
  appointment_invoke_arn  = module.lambda.appointment_invoke_arn
}

module "ecr" {
  source = "../../modules/ecr"
}
