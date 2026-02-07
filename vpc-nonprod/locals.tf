# Common tags for FinOps tracking
locals {
  common_tags = merge(
    {
      Environment = var.environment
      Project     = var.project_name
      CostCenter  = var.cost_center
      Owner       = var.owner
      ManagedBy   = "terraform"
      CreatedDate = timestamp()
    },
    var.additional_tags
  )

  # Calculate NAT Gateway count based on HA requirements
  nat_gateway_count = var.enable_nat_gateway ? (var.single_nat_gateway ? 1 : 2) : 0

  # Use provided AZs or get all available
  availability_zones = length(var.availability_zones) > 0 ? var.availability_zones : data.aws_availability_zones.available.names
}
