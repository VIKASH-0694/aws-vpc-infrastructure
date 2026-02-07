# VPC Endpoints for cost optimization (avoid NAT Gateway charges)

# S3 Gateway Endpoint (Free)
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  route_table_ids = concat(
    [aws_route_table.web.id],
    var.enable_nat_gateway && !var.single_nat_gateway ? [
      aws_route_table.app_az1[0].id,
      aws_route_table.app_az2[0].id
    ] : (var.enable_nat_gateway ? [aws_route_table.app_az1[0].id] : []),
    [aws_route_table.db_az1.id, aws_route_table.db_az2.id]
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-s3-endpoint"
      Note = "Gateway endpoint - no additional cost"
    }
  )
}

# DynamoDB Gateway Endpoint (Free)
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.aws_region}.dynamodb"

  route_table_ids = concat(
    [aws_route_table.web.id],
    var.enable_nat_gateway && !var.single_nat_gateway ? [
      aws_route_table.app_az1[0].id,
      aws_route_table.app_az2[0].id
    ] : (var.enable_nat_gateway ? [aws_route_table.app_az1[0].id] : []),
    [aws_route_table.db_az1.id, aws_route_table.db_az2.id]
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-dynamodb-endpoint"
      Note = "Gateway endpoint - no additional cost"
    }
  )
}

# Security Group for Interface Endpoints
resource "aws_security_group" "vpc_endpoints" {
  name_prefix = "${var.project_name}-${var.environment}-vpc-endpoints-"
  description = "Security group for VPC interface endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "HTTPS from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc-endpoints-sg"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
