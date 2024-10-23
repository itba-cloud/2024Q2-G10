resource "null_resource" "build_backend" {
  for_each = local.lambda_functions
  provisioner "local-exec" {
    working_dir = "${path.root}/../backend"
    command     = "zip -r $OUT_FILE $IN_FILES"
    environment = {
      "OUT_FILE" = "${each.value.file}.zip"
      "IN_FILES" = "node_modules ${each.value.file}"
    }
    interpreter = ["bash", "-c"]
  }
}

resource "aws_lambda_function" "plant_functions" {
  depends_on    = [null_resource.build_backend]
  for_each      = local.lambda_functions
  function_name = each.key
  role          = each.value.role
  handler       = each.value.handler
  runtime       = "nodejs18.x"
  filename      = "${path.root}/../backend/${each.value.file}.zip"

  environment {
    variables = {
      DB_NAME     = "postgres"
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_HOST     = var.proxy_host
      DB_PORT     = var.db_port
    }
  }

  vpc_config {
    security_group_ids = [var.security_group_id]
    subnet_ids         = var.lambda_subnet_ids
  }
}
