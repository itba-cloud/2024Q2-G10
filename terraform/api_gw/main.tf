# https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway
resource "aws_apigatewayv2_api" "planty_http_api" {
  name          = "planty-http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
    max_age       = 86400
  }
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.planty_http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_authorizer" "auth" {
  api_id           = aws_apigatewayv2_api.planty_http_api.id
  authorizer_type  = "JWT"
  identity_sources = ["$request.header.Authorization"]
  name             = "cognito-authorizer"

  jwt_configuration {
    audience = [var.cognito_client_id]
    issuer   = "https://${var.cognito_auth_endpoint}"
  }
}

resource "aws_apigatewayv2_route" "get_plants_route" {
  api_id    = aws_apigatewayv2_api.planty_http_api.id
  route_key = "GET /plants"
  target    = "integrations/${aws_apigatewayv2_integration.get_plants_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "post_plants_route" {
  api_id    = aws_apigatewayv2_api.planty_http_api.id
  route_key = "POST /plants"
  target    = "integrations/${aws_apigatewayv2_integration.create_plant_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "get_plant_by_id_route" {
  api_id    = aws_apigatewayv2_api.planty_http_api.id
  route_key = "GET /plants/{plantId}"
  target    = "integrations/${aws_apigatewayv2_integration.get_plant_by_id_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "delete_plant_by_id_route" {
  api_id    = aws_apigatewayv2_api.planty_http_api.id
  route_key = "DELETE /plants/{plantId}"
  target    = "integrations/${aws_apigatewayv2_integration.delete_plant_by_id_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "get_plant_waterings_route" {
  api_id    = aws_apigatewayv2_api.planty_http_api.id
  route_key = "GET /plants/{plantId}/waterings"
  target    = "integrations/${aws_apigatewayv2_integration.get_plant_waterings_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_route" "create_plant_waterings_route" {
  api_id    = aws_apigatewayv2_api.planty_http_api.id
  route_key = "POST /plants/{plantId}/waterings"
  target    = "integrations/${aws_apigatewayv2_integration.create_plant_watering_integration.id}"
  authorization_type = "JWT"
  authorizer_id = aws_apigatewayv2_authorizer.auth.id
}

resource "aws_apigatewayv2_integration" "get_plants_integration" {
  api_id                 = aws_apigatewayv2_api.planty_http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.get_plants.invoke_arn
  connection_type        = "INTERNET"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "create_plant_integration" {
  api_id                 = aws_apigatewayv2_api.planty_http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.create_plant.invoke_arn
  connection_type        = "INTERNET"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_plant_by_id_integration" {
  api_id                 = aws_apigatewayv2_api.planty_http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.get_plant_by_id.invoke_arn
  connection_type        = "INTERNET"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "delete_plant_by_id_integration" {
  api_id                 = aws_apigatewayv2_api.planty_http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.delete_plant_by_id.invoke_arn
  connection_type        = "INTERNET"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_plant_waterings_integration" {
  api_id                 = aws_apigatewayv2_api.planty_http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.get_plant_waterings.invoke_arn
  connection_type        = "INTERNET"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "create_plant_watering_integration" {
  api_id                 = aws_apigatewayv2_api.planty_http_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = var.create_plant_watering.invoke_arn
  connection_type        = "INTERNET"
  integration_method     = "POST"
  payload_format_version = "2.0"
}

resource "aws_lambda_permission" "get_plants_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvocationPlants"
  action        = "lambda:InvokeFunction"
  function_name = var.get_plants.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.planty_http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "create_plant_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvocationPlants"
  action        = "lambda:InvokeFunction"
  function_name = var.create_plant.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.planty_http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_plant_by_id_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvocationPlants"
  action        = "lambda:InvokeFunction"
  function_name = var.get_plant_by_id.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.planty_http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "delete_plant_by_id_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvocationPlants"
  action        = "lambda:InvokeFunction"
  function_name = var.delete_plant_by_id.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.planty_http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "get_plant_waterings_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvocationPlants"
  action        = "lambda:InvokeFunction"
  function_name = var.get_plant_waterings.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.planty_http_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "create_plant_watering_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvocationPlants"
  action        = "lambda:InvokeFunction"
  function_name = var.create_plant_watering.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.planty_http_api.execution_arn}/*/*"
}
