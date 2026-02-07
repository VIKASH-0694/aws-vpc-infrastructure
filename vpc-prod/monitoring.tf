# CloudWatch Alarms for FinOps monitoring

# NAT Gateway bandwidth monitoring
resource "aws_cloudwatch_metric_alarm" "nat_gateway_bandwidth" {
  count = var.enable_cloudwatch_alarms && var.enable_nat_gateway && !var.single_nat_gateway ? 2 : (var.enable_cloudwatch_alarms && var.enable_nat_gateway ? 1 : 0)

  alarm_name          = "${var.project_name}-${var.environment}-nat-gateway-${count.index + 1}-bandwidth"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "BytesOutToDestination"
  namespace           = "AWS/NATGateway"
  period              = "300"
  statistic           = "Sum"
  threshold           = var.nat_gateway_bandwidth_threshold
  alarm_description   = "NAT Gateway bandwidth usage alert for cost monitoring"
  treat_missing_data  = "notBreaching"

  dimensions = {
    NatGatewayId = count.index == 0 ? aws_nat_gateway.az1[0].id : aws_nat_gateway.az2[0].id
  }

  tags = local.common_tags
}

# VPC endpoint cost savings recommendation
resource "aws_cloudwatch_metric_alarm" "s3_data_transfer" {
  count = var.enable_cloudwatch_alarms ? 1 : 0

  alarm_name          = "${var.project_name}-${var.environment}-s3-data-transfer"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BytesOutToDestination"
  namespace           = "AWS/NATGateway"
  period              = "86400" # Daily
  statistic           = "Sum"
  threshold           = var.s3_data_transfer_threshold
  alarm_description   = "High S3 data transfer - consider VPC endpoint for cost savings"
  treat_missing_data  = "notBreaching"

  tags = local.common_tags
}
