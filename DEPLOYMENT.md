# VPC Deployment Guide

Two separate VPC configurations optimized for different environments.

## Directory Structure

```
vpc-prod/       # Production VPC (High Availability)
vpc-nonprod/    # Non-Production VPC (Cost Optimized)
vpc-ha/         # Original template (reference)
```

## Production VPC

**Location**: `vpc-prod/`

### Features
- 2 NAT Gateways (full HA)
- CIDR: 10.0.0.0/16
- 90-day Flow Log retention
- Full redundancy across AZs
- Cost: ~$70/month base

### Deploy
```bash
cd vpc-prod
terraform init
terraform plan
terraform apply
```

## Non-Production VPC

**Location**: `vpc-nonprod/`

### Features
- 1 NAT Gateway (cost optimized)
- CIDR: 10.1.0.0/16
- 7-day Flow Log retention
- Shared NAT across AZs
- Cost: ~$34/month base
- Savings: 51% vs production

### Deploy
```bash
cd vpc-nonprod
terraform init
terraform plan
terraform apply
```

## Cost Comparison

| Environment | NAT GWs | Monthly Cost | Use Case |
|-------------|---------|--------------|----------|
| Production  | 2       | ~$70         | Production workloads, HA required |
| Non-Prod    | 1       | ~$34         | Dev/Staging, cost optimization |
| Savings     | -       | $36/month    | 51% reduction |

## Key Differences

| Feature | Production | Non-Production |
|---------|-----------|----------------|
| CIDR | 10.0.0.0/16 | 10.1.0.0/16 |
| NAT Gateways | 2 (HA) | 1 (shared) |
| Flow Log Retention | 90 days | 7 days |
| Fault Tolerance | Full | Limited |
| Cost | Higher | Lower |

## Customization

Edit `terraform.tfvars` in each directory:

### Production
```hcl
environment          = "production"
enable_nat_gateway   = true
single_nat_gateway   = false  # HA
```

### Non-Production
```hcl
environment          = "staging"
enable_nat_gateway   = true
single_nat_gateway   = true   # Cost savings
```

## Cleanup

```bash
# Production
cd vpc-prod && terraform destroy

# Non-Production
cd vpc-nonprod && terraform destroy
```

## Best Practices

1. Deploy production VPC first
2. Test in non-prod before prod changes
3. Use separate AWS accounts for isolation
4. Enable VPC peering if needed
5. Monitor costs with CloudWatch alarms
6. Review monthly with AWS Cost Explorer
