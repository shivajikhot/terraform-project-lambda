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
}
module "ecr" {
  source = "../../modules/ecr"
}
