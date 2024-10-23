output "client_id" {
  value = aws_cognito_user_pool_client.plant_app_client.id
  description = "The ID of the app integration in cognito"
}

output "auth_endpoint" {
  value       = aws_cognito_user_pool.plant_app_pool.endpoint
  description = "Endpoint for authentication"
}

output "user_pool_id" {
    value     = aws_cognito_user_pool.plant_app_pool.id
}