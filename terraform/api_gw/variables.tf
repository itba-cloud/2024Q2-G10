variable "get_plants" {
  type = object({
    function_name = string
    invoke_arn    = string
  })
  description = "The function name and invocation ARN of the GET /plants lambda"
}

variable "create_plant" {
  type = object({
    function_name = string
    invoke_arn    = string
  })
  description = "The function name and invocation ARN of the POST /plants lambda"
}

variable "get_plant_by_id" {
  type = object({
    function_name = string
    invoke_arn    = string
  })
  description = "The function name and invocation ARN of the GET /plants/{id} lambda"
}

variable "delete_plant_by_id" {
  type = object({
    function_name = string
    invoke_arn    = string
  })
  description = "The function name and invocation ARN of the DELETE /plants/{id} lambda"
}

variable "get_plant_waterings" {
  type = object({
    function_name = string
    invoke_arn    = string
  })
  description = "The function name and invocation ARN of the GET /plants/{id}/waterings lambda"
}

variable "create_plant_watering" {
  type = object({
    function_name = string
    invoke_arn    = string
  })
  description = "The function name and invocation ARN of the POST /plants/{id}/waterings lambda"
}


variable "cognito_client_id" {
  type = string
  description = "The ID of the app integration in cognito"
}

variable "cognito_auth_endpoint" {
  type = string
  description = "Endpoint for authentication"
}