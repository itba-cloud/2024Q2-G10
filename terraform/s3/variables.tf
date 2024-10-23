variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "api_endpoint" {
  description = "The URL of the API Gateway to access the backend"
  type        = string
}

variable "cognito_user_pool_id" {
  description = "User pool in cognito"
  type        = string
}

variable "cognito_client_id" {
  description = "The ID of the app integration in cognito"
  type        = string
}

variable "region" {
  type        = string
}
