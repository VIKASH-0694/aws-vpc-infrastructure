# High Availability 3-Tier VPC with FinOps Best Practices

Production-grade VPC infrastructure with cost optimization and monitoring.

## Architecture

- **Web Tier**: 2 public subnets across 2 AZs (10.0.1.0/24, 10.0.2.0/24)
- **Application Tier**: 2 private subnets across 2 AZs (10.0.11.0/24, 10.0.12.0/24)
- **Database Tier**: 2 private subnets across 2 AZs (10.0.21.0/24, 10.0.22.0/24)
- NAT Gateways with HA support (configurable)
- VPC Endpoints for S3 and DynamoDB (cost savings)
- VPC Flow Logs for security monitoring
- CloudWatch alarms for cost monitoring

## FinOps Features

### Cost Optimization
- Configurable NAT Gateway deployment (HA, single, or none)
- Free VPC Gateway Endpoints (S3, DynamoDB)
- Environment-based resource provisioning
- Cost allocation tags on all resources
- Monthly cost estimates in outputs

### Monitoring
- NAT Gateway bandwidth alerts
- S3 data transfer monitoring
- VPC Flow Logs with environment-based retention

### Tagging Strategy
All resources tagged with:
- Environment, Project, CostCenter, Owner, ManagedBy

## Cost Comparison

| Environment | NAT Setup | Monthly Base Cost |
|-------------|-----------|-------------------|
| Production  | 2 NAT GW  | ~$64/month        |
| Staging     | 1 NAT GW  | ~$32/month        |
| Development | No NAT    | $0/month          |

See `cost-optimization.md` for detailed FinOps strategies.

## Usage

### Production Deployment
```bash
terraform init
terraform plan -var="environment=production" -var="enable_nat_gateway=true" -var="single_nat_gateway=false"
terraform apply
```

### Staging Deployment (Cost Optimized)
```bash
terraform plan -var="environment=staging" -var="enable_nat_gateway=true" -var="single_nat_gateway=true"
terraform apply
```

### Development Deployment (Maximum Savings)
```bash
terraform plan -var="environment=development" -var="enable_nat_gateway=false"
terraform apply
```

## Configuration

Copy `terraform.tfvars.example` to `terraform.tfvars` and customize:

```hcl
environment          = "production"
project_name         = "myapp"
cost_center          = "engineering"
owner                = "platform-team"
enable_nat_gateway   = true
single_nat_gateway   = false
enable_vpc_flow_logs = true
```

## Outputs

- VPC and subnet IDs
- NAT Gateway IDs
- VPC Endpoint IDs
- Monthly cost estimate

## Cleanup

```bash
terraform destroy
```

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Cleanup

```bash
terraform destroy
```
