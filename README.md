# AWS VPC Infrastructure - Production Ready

Enterprise-grade VPC configurations with FinOps best practices.

## Quick Start

```bash
# Production VPC (High Availability)
cd vpc-prod
terraform init
terraform plan
terraform apply

# Non-Production VPC (Cost Optimized)
cd vpc-nonprod
terraform init
terraform plan
terraform apply
```

## Configurations

### 1. Production VPC (`vpc-prod/`)
- **CIDR**: 10.0.0.0/16
- **NAT Gateways**: 2 (full HA)
- **Cost**: ~$70/month
- **Use**: Production workloads

### 2. Non-Production VPC (`vpc-nonprod/`)
- **CIDR**: 10.1.0.0/16
- **NAT Gateways**: 1 (cost optimized)
- **Cost**: ~$34/month
- **Use**: Dev/Staging environments

### 3. Template VPC (`vpc-ha/`)
- Flexible configuration
- Customizable for any environment

## Features

### Architecture
- 3-tier design (Web, App, Database)
- Multi-AZ deployment
- Public and private subnets
- Internet Gateway
- NAT Gateways (configurable)

### Security
- VPC Flow Logs
- Network ACLs
- Security groups ready
- Isolated database tier

### Cost Optimization
- VPC Endpoints (S3, DynamoDB)
- Configurable NAT Gateway deployment
- Environment-based resource provisioning
- CloudWatch cost monitoring
- Complete cost allocation tagging

### Monitoring
- VPC Flow Logs
- CloudWatch alarms
- NAT Gateway bandwidth alerts
- Cost anomaly detection

## Requirements

- Terraform >= 1.9.0
- AWS Provider >= 5.100
- AWS CLI >= 2.15.0
- Valid AWS credentials

## Cost Comparison

| Environment | NAT GWs | Base Cost | Savings |
|-------------|---------|-----------|---------|
| Production  | 2       | $70/mo    | -       |
| Non-Prod    | 1       | $34/mo    | 51%     |

## Documentation

- [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment guide
- [VERSION.md](VERSION.md) - Version information
- [vpc-ha/cost-optimization.md](vpc-ha/cost-optimization.md) - FinOps strategies

## Directory Structure

```
.
├── vpc-prod/              # Production VPC
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── flow-logs.tf
│   ├── endpoints.tf
│   ├── monitoring.tf
│   ├── locals.tf
│   └── terraform.tfvars
├── vpc-nonprod/           # Non-Production VPC
│   └── (same structure)
├── vpc-ha/                # Template VPC
│   └── (same structure)
├── DEPLOYMENT.md
├── VERSION.md
└── README.md
```

## Quick Commands

```bash
# Initialize
terraform init

# Validate
terraform validate

# Plan
terraform plan

# Apply
terraform apply

# Destroy
terraform destroy

# Format
terraform fmt -recursive

# Upgrade providers
terraform init -upgrade
```

## Customization

Edit `terraform.tfvars` in each directory:

```hcl
environment          = "production"
project_name         = "myapp"
cost_center          = "engineering"
owner                = "platform-team"
enable_nat_gateway   = true
single_nat_gateway   = false
```

## Best Practices

1. Deploy to non-prod first
2. Test thoroughly before prod
3. Use separate AWS accounts
4. Enable VPC Flow Logs
5. Monitor costs monthly
6. Tag all resources
7. Review security regularly

## Support

For issues or questions:
1. Check documentation
2. Review Terraform plan output
3. Validate configuration
4. Check AWS service limits

## License

MIT License - Use freely for your projects
