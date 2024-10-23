# Region
variable "region" {
  description = "The AWS region where the application will be deployed"
  type        = string
}

# VPC Parameters
variable "vpc_lambda_subnet_count" {
  description = "The number of subnets for Lambda functions"
  type        = number
}

variable "vpc_rds_subnet_count" {
  description = "The number of subnets for RDS instances"
  type        = number
}

# RDS Parameters
variable "rds_db_username" {
  description = "The username for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "rds_db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  sensitive   = true # Mark as sensitive to hide it in logs
}

variable "rds_secret_name" {
  description = "The RDS Proxy secret name"
  type        = string
  sensitive   = true # Mark as sensitive to hide it in logs
}

# S3 parameters
variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
}

# Cognito
variable "cognito_user_pool_domain" {
  description = "Cognito user pool domain"
  type        = string
}