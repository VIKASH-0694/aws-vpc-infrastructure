# Terraform Variables Configuration Guide

All configuration values are now passed through `terraform.tfvars` for easy customization.

## Quick Start

1. Copy example file:
```bash
cp terraform.tfvars.example terraform.tfvars
```

2. Edit values:
```bash
# Edit terraform.tfvars with your values
```

3. Deploy:
```bash
terraform init
terraform plan
terraform apply
```

## Available Variables

### Required Variables

#### Project Information
```hcl
environment   = "production"     # development, staging, or production
project_name  = "myapp"          # Your project name
cost_center   = "engineering"    # Cost center for billing
owner         = "platform-team"  # Team or individual owner
aws_region    = "us-east-1"      # AWS region
```

### VPC Configuration

#### Network Settings
```hcl
vpc_cidr             = "10.0.0.0/16"  # VPC CIDR block
enable_dns_hostnames = true            # Enable DNS hostnames
enable_dns_support   = true            # Enable DNS support
```

#### Subnet Configuration
```hcl
# Web tier (public) subnets
web_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]

# Application tier (private) subnets
app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

# Database tier (isolated) subnets
db_subnet_cidrs  = ["10.0.21.0/24", "10.0.22.0/24"]
```

#### Availability Zones
```hcl
# Leave empty to use all available AZs
availability_zones = []

# Or specify specific AZs
availability_zones = ["us-east-1a", "us-east-1b"]
```

#### Public Subnet Settings
```hcl
map_public_ip_on_launch = true  # Auto-assign public IPs
```

### High Availability

#### NAT Gateway Configuration
```hcl
enable_nat_gateway = true   # Enable NAT Gateways
single_nat_gateway = false  # false = 2 NAT GWs (HA), true = 1 NAT GW (cost savings)
```

**Cost Impact**:
- `single_nat_gateway = false`: ~$64/month (HA)
- `single_nat_gateway = true`: ~$32/month (cost optimized)
- `enable_nat_gateway = false`: $0/month (no outbound internet)

### VPC Endpoints

#### Gateway Endpoints (Free)
```hcl
enable_s3_endpoint       = true  # S3 Gateway Endpoint
enable_dynamodb_endpoint = true  # DynamoDB Gateway Endpoint
```

**Savings**: Avoid NAT Gateway data processing charges ($0.045/GB)

### Security & Compliance

#### VPC Flow Logs
```hcl
enable_vpc_flow_logs     = true  # Enable flow logs
flow_logs_retention_days = 90    # Retention period (days)
```

**Retention Recommendations**:
- Production: 90 days
- Staging: 30 days
- Development: 7 days

### Monitoring

#### CloudWatch Alarms
```hcl
enable_cloudwatch_alarms = true  # Enable monitoring alarms

# NAT Gateway bandwidth threshold (bytes)
nat_gateway_bandwidth_threshold = 5000000000  # 5GB

# S3 data transfer threshold (bytes)
s3_data_transfer_threshold = 100000000000  # 100GB
```

### Additional Tags

```hcl
additional_tags = {
  Compliance   = "required"
  Backup       = "daily"
  AutoShutdown = "enabled"
}
```

## Environment-Specific Examples

### Production Configuration

```hcl
# terraform.tfvars
environment          = "production"
project_name         = "myapp"
cost_center          = "engineering"
owner                = "platform-team"
aws_region           = "us-east-1"

vpc_cidr             = "10.0.0.0/16"
enable_dns_hostnames = true
enable_dns_support   = true

web_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
db_subnet_cidrs  = ["10.0.21.0/24", "10.0.22.0/24"]

availability_zones      = []
map_public_ip_on_launch = true

# High Availability
enable_nat_gateway = true
single_nat_gateway = false  # 2 NAT Gateways

# Cost Optimization
enable_s3_endpoint       = true
enable_dynamodb_endpoint = true

# Security
enable_vpc_flow_logs     = true
flow_logs_retention_days = 90

# Monitoring
enable_cloudwatch_alarms        = true
nat_gateway_bandwidth_threshold = 5000000000
s3_data_transfer_threshold      = 100000000000

additional_tags = {
  Compliance = "required"
  Backup     = "daily"
}
```

**Monthly Cost**: ~$70

### Staging Configuration

```hcl
# terraform.tfvars
environment          = "staging"
project_name         = "myapp"
cost_center          = "engineering"
owner                = "dev-team"
aws_region           = "us-east-1"

vpc_cidr             = "10.1.0.0/16"  # Different CIDR
enable_dns_hostnames = true
enable_dns_support   = true

web_subnet_cidrs = ["10.1.1.0/24", "10.1.2.0/24"]
app_subnet_cidrs = ["10.1.11.0/24", "10.1.12.0/24"]
db_subnet_cidrs  = ["10.1.21.0/24", "10.1.22.0/24"]

availability_zones      = []
map_public_ip_on_launch = true

# Cost Optimized
enable_nat_gateway = true
single_nat_gateway = true  # 1 NAT Gateway (save $32/month)

# Cost Optimization
enable_s3_endpoint       = true
enable_dynamodb_endpoint = true

# Security
enable_vpc_flow_logs     = true
flow_logs_retention_days = 30  # Shorter retention

# Monitoring
enable_cloudwatch_alarms        = true
nat_gateway_bandwidth_threshold = 5000000000
s3_data_transfer_threshold      = 100000000000

additional_tags = {
  AutoShutdown = "enabled"
}
```

**Monthly Cost**: ~$34 (51% savings)

### Development Configuration

```hcl
# terraform.tfvars
environment          = "development"
project_name         = "myapp"
cost_center          = "engineering"
owner                = "dev-team"
aws_region           = "us-east-1"

vpc_cidr             = "10.2.0.0/16"  # Different CIDR
enable_dns_hostnames = true
enable_dns_support   = true

web_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
app_subnet_cidrs = ["10.2.11.0/24", "10.2.12.0/24"]
db_subnet_cidrs  = ["10.2.21.0/24", "10.2.22.0/24"]

availability_zones      = []
map_public_ip_on_launch = true

# Maximum Cost Savings
enable_nat_gateway = false  # No NAT Gateway (save $64/month)

# Cost Optimization
enable_s3_endpoint       = true
enable_dynamodb_endpoint = true

# Minimal Monitoring
enable_vpc_flow_logs     = false  # Disable for cost savings
flow_logs_retention_days = 7

# Monitoring
enable_cloudwatch_alarms        = false  # Disable for cost savings
nat_gateway_bandwidth_threshold = 5000000000
s3_data_transfer_threshold      = 100000000000

additional_tags = {
  AutoShutdown = "enabled"
  Environment  = "temporary"
}
```

**Monthly Cost**: ~$0 (100% savings on networking)

## Variable Validation

### Environment
- Must be: `development`, `staging`, or `production`
- Validated automatically

### CIDR Blocks
- Must be valid IPv4 CIDR notation
- Avoid overlapping with existing VPCs
- Recommended sizes:
  - VPC: /16 (65,536 IPs)
  - Subnets: /24 (256 IPs each)

### Subnet Count
- Must provide exactly 2 CIDR blocks per tier
- One for each availability zone

## Cost Optimization Matrix

| Configuration | NAT GWs | Flow Logs | Monthly Cost | Use Case |
|---------------|---------|-----------|--------------|----------|
| Production    | 2       | 90 days   | ~$70         | Production workloads |
| Staging       | 1       | 30 days   | ~$34         | Pre-production testing |
| Development   | 0       | Disabled  | ~$0          | Development/testing |

## Best Practices

### 1. Use Separate CIDR Blocks
```hcl
# Production
vpc_cidr = "10.0.0.0/16"

# Staging
vpc_cidr = "10.1.0.0/16"

# Development
vpc_cidr = "10.2.0.0/16"
```

### 2. Enable VPC Endpoints
Always enable S3 and DynamoDB endpoints (free):
```hcl
enable_s3_endpoint       = true
enable_dynamodb_endpoint = true
```

### 3. Right-Size NAT Gateways
- Production: 2 NAT Gateways (HA)
- Staging: 1 NAT Gateway (cost savings)
- Development: 0 NAT Gateways (maximum savings)

### 4. Adjust Flow Log Retention
```hcl
# Production
flow_logs_retention_days = 90

# Staging
flow_logs_retention_days = 30

# Development
flow_logs_retention_days = 7
```

### 5. Use Additional Tags
```hcl
additional_tags = {
  CostCenter   = "engineering"
  Project      = "web-app"
  Compliance   = "required"
  Backup       = "daily"
  AutoShutdown = "enabled"  # For non-prod
}
```

## Validation Commands

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Check plan
terraform plan

# Show variables
terraform show -json | jq '.values.root_module.resources[].values'
```

## Troubleshooting

### Issue: CIDR Overlap
**Solution**: Use different CIDR blocks for each environment

### Issue: Subnet Too Small
**Solution**: Use /24 or larger for subnets

### Issue: NAT Gateway Costs
**Solution**: 
- Use single NAT Gateway for non-prod
- Disable NAT Gateway for development
- Enable VPC Endpoints

### Issue: Flow Logs Costs
**Solution**: Reduce retention period or disable for development

## Migration from Hardcoded Values

If upgrading from hardcoded configuration:

1. Review current values:
```bash
terraform show
```

2. Create terraform.tfvars with current values

3. Update and test:
```bash
terraform plan  # Should show no changes
```

4. Customize as needed

---

**Last Updated**: February 7, 2026
