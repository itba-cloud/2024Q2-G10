output "id" {
  value = aws_db_instance.rds_db.identifier
}

output "address" {
  value = aws_db_instance.rds_db.address
}

output "port" {
  value = aws_db_instance.rds_db.port
}