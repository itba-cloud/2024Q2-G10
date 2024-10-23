output "vpc_id" {
  value = aws_vpc.plantapp_vpc.id
  description = "ID of the VPC"
}

output "rds_subnet_group_id" {
  value       = aws_db_subnet_group.rds_subnet_group.id
  description = "The ID of the RDS DB subnet group"
}

output "rds_subnet_group_name" {
  value       = aws_db_subnet_group.rds_subnet_group.name
  description = "The ID of the RDS DB subnet group"
}

output "rds_subnet_ids" {
  value       = aws_db_subnet_group.rds_subnet_group.subnet_ids
  description = "The IDs of the RDS subnets"
}

output "lambda_subnet_group_id" {
  value       = aws_db_subnet_group.lambda_subnet_group.id
  description = "The ID of the Lambda subnet group"
}

output "lambda_subnet_group_name" {
  value       = aws_db_subnet_group.lambda_subnet_group.name
  description = "The ID of the Lambda subnet group"
}

output "lambda_subnet_ids" {
  value       = aws_db_subnet_group.lambda_subnet_group.subnet_ids
  description = "The IDs of the lambda subnets"
}