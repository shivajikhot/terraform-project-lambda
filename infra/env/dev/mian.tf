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
  integration_uri = module.lambda.hello_world_invoke_arn
}
module "ecr" {
  source = "../../modules/ecr"
}
