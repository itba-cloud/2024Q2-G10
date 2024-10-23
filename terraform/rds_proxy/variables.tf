variable "security_group_id" {
  description = "The security group ID for the RDS proxy"
  type        = string
}

variable "vpc_subnet_ids" {
  description = "List of VPC subnet IDs for the RDS Proxy"
  type        = list(string)
}

variable "db_secret_arn" {
  description = "The ARN of the secret for the RDS proxy authentication"
  type        = string
}

variable "labrole_arn" {
  description = "LabRole ARN. It can be found in IAM > Roles"
  type = string
  sensitive = true
}

variable "planty_db_identifier" {
  description = "The identifier of the RDS database"
  type        = string
}