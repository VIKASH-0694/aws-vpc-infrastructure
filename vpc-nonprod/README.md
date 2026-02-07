# Non-Production VPC - Cost Optimized Configuration

Cost-optimized 3-tier VPC for development and staging environments.

## Configuration

- **Environment**: Staging/Development
- **CIDR**: 10.1.0.0/16
- **NAT Gateways**: 1 (shared across AZs)
- **VPC Flow Logs**: Enabled (7-day retention)
- **VPC Endpoints**: S3, DynamoDB (free)

## Architecture

### Web Tier (Public)
- 10.1.1.0/24 (AZ1)
- 10.1.2.0/24 (AZ2)

### Application Tier (Private)
- 10.1.11.0/24 (AZ1) → NAT Gateway AZ1 (shared)
- 10.1.12.0/24 (AZ2) → NAT Gateway AZ1 (shared)

### Database Tier (Private)
- 10.1.21.0/24 (AZ1)
- 10.1.22.0/24 (AZ2)

## Cost Estimate

- NAT Gateway: ~$32/month (base)
- Data Processing: $0.045/GB
- VPC Flow Logs: ~$1-2/month
- **Total Base**: ~$34/month
- **Savings vs Prod**: ~$36/month (51% reduction)

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## Cost Optimization Features

- Single NAT Gateway (50% cost reduction)
- Shorter Flow Log retention (7 days vs 90)
- Shared NAT Gateway across AZs
- Same security features as production
- VPC Endpoints for S3/DynamoDB traffic

## Trade-offs

- Single NAT Gateway = single point of failure (acceptable for non-prod)
- Both AZs route through AZ1 NAT Gateway
- Cross-AZ data transfer charges apply
