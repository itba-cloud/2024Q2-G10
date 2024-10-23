output "lambdas_sg_id" {
  description = "The ID of the Lambda security group"
  value       = aws_security_group.lambdas_sg.id
}

output "lambda_table_creator_sg_id" {
  description = "The ID of the security group of the lambda that handles DB table creation"
  value       = aws_security_group.lambda_table_creator_sg.id
}

output "rds_proxy_sg_id" {
  description = "The ID of the RDS Proxy security group"
  value       = aws_security_group.planty_db_proxy_sg.id
}

output "rds_sg_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.planty_db_sg.id
}
