##### VPC

resource "aws_vpc" "plantapp_vpc" {
  cidr_block = local.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = local.vpc_name
  }
}

###### Lambda Subnets

# Data source to retrieve the available availability zones in the region
data "aws_availability_zones" "available" {
    state = "available"
}

resource "aws_route_table" "lambda_private" {
  vpc_id = aws_vpc.plantapp_vpc.id
  tags = {
    Name = "lambda-private-route-table"
  }
}

resource "aws_subnet" "lambda_subnet" {
  count             = var.lambda_subnet_count
  vpc_id            = aws_vpc.plantapp_vpc.id
  cidr_block        = cidrsubnet(local.vpc_cidr, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
}

resource "aws_route_table_association" "lambda_subnet_assoc" {
  count          = var.lambda_subnet_count
  subnet_id      = aws_subnet.lambda_subnet[count.index].id
  route_table_id = aws_route_table.lambda_private.id
}

resource "aws_db_subnet_group" "lambda_subnet_group" {
  name       = "lambda-subnet-group"
  subnet_ids = aws_subnet.lambda_subnet[*].id

  tags = {
    Name = "lambda-subnet-group"
  }
}

###### RDS Subnets

resource "aws_route_table" "rds_private" {
  vpc_id = aws_vpc.plantapp_vpc.id
  tags = {
    Name = "data-private-route-table"
  }
}

resource "aws_subnet" "rds_subnet" {
  count             = var.rds_subnet_count
  vpc_id            = aws_vpc.plantapp_vpc.id
  cidr_block        = cidrsubnet(local.vpc_cidr, 8, count.index + 100)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = false
}

resource "aws_route_table_association" "rds_subnet_assoc" {
  count          = var.rds_subnet_count
  subnet_id      = aws_subnet.rds_subnet[count.index].id
  route_table_id = aws_route_table.rds_private.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.rds_subnet[*].id

  tags = {
    Name = "rds-subnet-group"
  }
}

##### VPC endpoints
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id       = aws_vpc.plantapp_vpc.id
  service_name = "com.amazonaws.${var.vpc_region}.s3"
  route_table_ids = [aws_vpc.plantapp_vpc.default_route_table_id]

  tags = {
    Name = "${local.vpc_name}-s3-gateway"
  }
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id            = aws_vpc.plantapp_vpc.id
  service_name      = "com.amazonaws.${var.vpc_region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.lambda_private.id]

  tags = {
    Name = "dynamodb-endpoint"
  }
}
