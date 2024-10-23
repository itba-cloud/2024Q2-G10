resource "aws_db_instance" "rds_db" {
  username = var.db_username
  password = var.db_password

  identifier        = local.rds_db_name
  engine            = "postgres"
  engine_version    = "16.3"
  port              = 5432
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  multi_az          = true
  apply_immediately = true

  # Storage settings
  storage_type          = "gp3"
  max_allocated_storage = 20

  # Unnecesary characteristics
  performance_insights_enabled = false
  monitoring_interval          = 0
  skip_final_snapshot          = true

  # Security group
  vpc_security_group_ids = [var.security_group_id]

  # Subnets
  db_subnet_group_name = var.subnet_group_name

  tags = {
    Name        = local.rds_db_name
    Environment = "dev/test"
  }
}

resource "null_resource" "build_table_creator" {
  provisioner "local-exec" {
    working_dir = "${path.root}/../backend"
    command     = "zip -r $OUT_FILE $IN_FILES"
    environment = {
      "OUT_FILE" = "tableCreator.js.zip"
      "IN_FILES" = "node_modules tableCreator.js schema.sql"
    }
    interpreter = ["bash", "-c"]
  }
}

resource "aws_lambda_function" "table_creator" {
  depends_on    = [null_resource.build_table_creator]
  function_name = "rds_table_creator"
  runtime       = "nodejs18.x"
  handler       = "tableCreator.handler"
  role          = var.labrole_arn

  environment {
    variables = {
      DB_NAME     = "postgres"
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_HOST     = aws_db_instance.rds_db.address
      DB_PORT     = aws_db_instance.rds_db.port
    }
  }

  filename = "${path.root}/../backend/tableCreator.js.zip"

  vpc_config {
    subnet_ids         = var.lambda_subnet_ids
    security_group_ids = [var.tablecreator_security_group_id]
  }
}

resource "null_resource" "db_setup" {
  depends_on = [aws_lambda_function.table_creator, aws_db_instance.rds_db]
  provisioner "local-exec" {
    command = "aws lambda invoke --region $REGION --function-name $LAMBDA_NAME /dev/null"
    environment = {
      "LAMBDA_NAME" = aws_lambda_function.table_creator.function_name
      "REGION"      = var.region
    }
    interpreter = ["bash", "-c"]
  }
}
