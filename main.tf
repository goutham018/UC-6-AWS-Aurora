provider "aws" {
  region = var.region
}

module "dynamodb" {
  source      = "./modules/dynamo-db"
  table_name  = var.dynamodb_table_name
  read_capacity_units  = var.read_capacity_units
  write_capacity_units = var.write_capacity_units
}

module "lambda" {
  source      = "./modules/lambda"
  function_name = var.lambda_function_name
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  role_arn      = module.iam_role.arn
  environment_variables = {
    DYNAMODB_TABLE_NAME = module.dynamodb.table_name
  }
}

module "api_gateway" {
  source      = "./modules/api-gateway"
  rest_api_name = var.api_gateway_name
  lambda_function_arn = module.lambda.lambda_function_arn
  region = var.region
}

module "iam_role" {
  source      = "./modules/iam"
  role_name   = var.iam_role_name
  policy_arn  = var.iam_policy_arn
}
