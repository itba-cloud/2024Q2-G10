locals {
  vpc_cidr                = "10.0.0.0/16"
  vpc_name                = "planty-vpc"

  subnets = {
    lambda = {
      count       = var.lambda_subnet_count
      cidr_offset = 0
      route_table_name = "lambda-private-route-table"
    },
    rds = {
      count       = var.rds_subnet_count
      cidr_offset = 100 
      route_table_name = "rds-private-route-table"
    }
  }

  vpc_endpoints = {
    s3        = "com.amazonaws.${var.vpc_region}.s3"
    dynamodb  = "com.amazonaws.${var.vpc_region}.dynamodb"
  }
}