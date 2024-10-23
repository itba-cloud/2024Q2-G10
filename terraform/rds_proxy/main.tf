
resource "aws_db_proxy" "planty_db_proxy" {
  name                   = "planty-db-proxy"
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = var.labrole_arn
  vpc_security_group_ids = [var.security_group_id]
  vpc_subnet_ids         = var.vpc_subnet_ids

  auth {
    auth_scheme = "SECRETS"
    description = "planty"
    iam_auth    = "DISABLED"
    secret_arn  = var.db_secret_arn
  }

  tags = {
    Name        = "planty-db-proxy"
    Environment = "dev/test"
  }
}

resource "aws_db_proxy_default_target_group" "planty_db_target_group" {
  db_proxy_name = aws_db_proxy.planty_db_proxy.name

  connection_pool_config {
    connection_borrow_timeout    = 120
    max_connections_percent      = 100
    max_idle_connections_percent  = 50
  }
}

resource "aws_db_proxy_target" "planty_db_target" {
  db_instance_identifier = var.planty_db_identifier
  db_proxy_name          = aws_db_proxy.planty_db_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.planty_db_target_group.name
}
