# Production VPC - High Availability Configuration

Production-grade 3-tier VPC with full redundancy and security features.

## Configuration

- **Environment**: Production
- **CIDR**: 10.0.0.0/16
- **NAT Gateways**: 2 (one per AZ for HA)
- **VPC Flow Logs**: Enabled (90-day retention)
- **VPC Endpoints**: S3, DynamoDB (free)

## Architecture

### Web Tier (Public)
- 10.0.1.0/24 (AZ1)
- 10.0.2.0/24 (AZ2)

### Application Tier (Private)
- 10.0.11.0/24 (AZ1) → NAT Gateway AZ1
- 10.0.12.0/24 (AZ2) → NAT Gateway AZ2

### Database Tier (Private)
- 10.0.21.0/24 (AZ1)
- 10.0.22.0/24 (AZ2)

## Cost Estimate

- NAT Gateways: ~$64/month (base)
- Data Processing: $0.045/GB
- VPC Flow Logs: ~$5-10/month
- **Total Base**: ~$70/month

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## Features

- Multi-AZ deployment for fault tolerance
- Redundant NAT Gateways (no single point of failure)
- VPC Flow Logs for security monitoring
- CloudWatch alarms for cost monitoring
- Complete cost allocation tagging
