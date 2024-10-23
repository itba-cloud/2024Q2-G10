resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "${var.secret_name}-secret"
  description = "Secret for RDS"
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}