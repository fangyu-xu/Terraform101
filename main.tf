terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.78"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Owner = "Boss"
    }
  }
}

module "lambda" {
  source                   = "git::https://github.com/trawa-energy/terraform-modules.git//lambda?ref=v1.13.0"
  alarm_log_filter_pattern = "[(w1=\"*ERROR*\" && w1!=\"*UNAUTHORIZED*\") || w1=\"*Task timed out*\"]" # matches either "ERROR" or "Task timed out" 
  name                     = var.project_name
  route                    = replace(var.project_name, "-api", "")
  api_gateway_name         = var.api_gateway_name
  s3_bucket                = var.lambda_bucket
  open_access              = true
  timeout                  = 30
  memory_size              = 1024
}

