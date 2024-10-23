variable "vpc_region" {
  description = "The AWS region where the VPC will be created"
  type        = string
}

variable "lambda_subnet_count" {
  description = "The number of subnets for Lambda functions"
  type        = number
}

variable "rds_subnet_count" {
  description = "The number of subnets for RDS instances"
  type        = number
}