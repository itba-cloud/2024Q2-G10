variable "proxy_host" {
  description = "The endpoint address of the RDS Proxy"
  type        = string
}

variable "db_username" {
  description = "The username to connect to the RDS database"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS database user"
  type        = string
}

variable "db_port" {
  description = "The port on which the database is listening"
  type        = string
}

variable "labrole_arn" {
  description = "LabRole ARN. It can be found in IAM > Roles"
  type = string
  sensitive = true
}

variable "lambda_subnet_ids" {
  description = "The list of subnet IDs for the Lambda functions"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID for the Lambda functions"
  type        = string
}
