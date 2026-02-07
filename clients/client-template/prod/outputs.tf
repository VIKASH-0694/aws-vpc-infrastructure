output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "web_subnet_ids" {
  description = "Web tier subnet IDs"
  value       = [aws_subnet.web_az1.id, aws_subnet.web_az2.id]
}

output "app_subnet_ids" {
  description = "Application tier subnet IDs"
  value       = [aws_subnet.app_az1.id, aws_subnet.app_az2.id]
}

output "db_subnet_ids" {
  description = "Database tier subnet IDs"
  value       = [aws_subnet.db_az1.id, aws_subnet.db_az2.id]
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = var.enable_nat_gateway && !var.single_nat_gateway ? [aws_nat_gateway.az1[0].id, aws_nat_gateway.az2[0].id] : (var.enable_nat_gateway ? [aws_nat_gateway.az1[0].id] : [])
}

output "s3_endpoint_id" {
  description = "S3 VPC Endpoint ID"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB VPC Endpoint ID"
  value       = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].id : null
}

output "monthly_cost_estimate" {
  description = "Estimated monthly cost for NAT Gateways (base cost only, excludes data transfer)"
  value       = var.enable_nat_gateway ? (var.single_nat_gateway ? "$32/month (1 NAT Gateway)" : "$64/month (2 NAT Gateways)") : "$0/month (No NAT Gateways)"
}
