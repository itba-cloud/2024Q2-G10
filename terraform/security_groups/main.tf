resource "aws_security_group" "lambdas_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambdas-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lambda_table_creator_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-tablecreator-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "planty_db_proxy_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lambdas_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "planty-db-proxy-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "planty_db_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.planty_db_proxy_sg.id, aws_security_group.lambda_table_creator_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "planty-db-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}
