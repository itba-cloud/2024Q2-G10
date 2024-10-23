output "address" {
  description = "The RDS Proxy address"
  value = aws_db_proxy.planty_db_proxy.endpoint
}