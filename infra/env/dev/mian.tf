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
  patient_lambda_arn         = module.lambda.patient_lambda_arn
  appointment_lambda_arn     = module.lambda.appointment_lambda_arn
  region                 = var.aws_region
}
module "ecr" {
  source = "../../modules/ecr"
}
