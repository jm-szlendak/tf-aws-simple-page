provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

locals {
  base_name = "simplepage"

  item_key = "item_key"
}

module "get_handler" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.1"

  function_name = "${local.base_name}-get-handler-${var.environment}"
  handler       = "get-handler.handler"
  runtime       = "nodejs20.x"
  source_path   = ["${path.module}/src/get-handler.js"]
  environment_variables = {
    "TABLE_NAME" = module.table.dynamodb_table_id
    "KEY" = local.item_key
  }
  attach_policy_statements = true
  policy_statements = {
    read_dynamodb = {
      effect    = "Allow"
      actions   = ["dynamodb:GetItem"]
      resources = [module.table.dynamodb_table_arn]
    }
  }
}


module "set_handler" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "7.2.1"

  function_name = "${local.base_name}-set-handler-${var.environment}"
  handler       = "set-handler.handler"
  runtime       = "nodejs20.x"
  source_path   = ["${path.module}/src/set-handler.js"]
  environment_variables = {
    "TABLE_NAME" = module.table.dynamodb_table_id
    "KEY" = local.item_key
  }
  attach_policy_statements = true
  policy_statements = {
    read_dynamodb = {
      effect    = "Allow"
      actions   = ["dynamodb:UpdateItem"]
      resources = [module.table.dynamodb_table_arn]
    }
  }
}

module "table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "4.0.0"

  name                        = "${local.base_name}-table-${var.environment}"
  hash_key                    = "key"
  table_class                 = "STANDARD"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "key"
      type = "S"
    }
  ]
}
