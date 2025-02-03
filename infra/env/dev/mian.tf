module "iam" {
  source = "../../modules/iam"
}

module "lambda" {
  source                        = "../../modules/lambda"
  hello_world_image_uri     = var.hello_world_image_uri
  lambda_execution_role_arn     = module.iam.lambda_execution_role_arn
}

module "apigateway" {
  source                     = "../../modules/apigateway"
  patient_lambda_arn         = module.lambda.hello_world_lambda_arn
  region                 = "us-west-1"
}
module "ecr" {
  source = "../../modules/ecr"
}
