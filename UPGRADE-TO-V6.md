# Upgrade Guide: AWS Provider v5 to v6

## Overview

AWS Provider v6.31.0 (latest as of Feb 2026) includes new features and breaking changes.

## Should You Upgrade?

### Stay on v5.100 if:
- Production stability is critical
- No immediate need for v6 features
- Team needs time to test
- Current setup works well

### Upgrade to v6.31 if:
- Need regional NAT Gateways
- Want latest Lambda features
- Starting new projects
- Can test thoroughly first

## New Features in v6.31

### 1. Regional NAT Gateways
```hcl
resource "aws_vpc_nat_gateway" "regional" {
  vpc_id            = aws_vpc.main.id
  availability_mode = "regional"  # New!
  
  # Auto-provisions across AZs
  auto_provision_zones = true
  auto_scaling_ips     = true
}
```

**Benefits**:
- Automatic multi-AZ deployment
- Auto-scaling IP addresses
- Simplified configuration
- Better HA without manual setup

### 2. Enhanced Lambda
```hcl
resource "aws_lambda_function" "example" {
  # ... existing config ...
  
  capacity_provider_config {  # New!
    capacity_provider = "FARGATE"
  }
  
  publish_to = "latest"  # New!
}
```

### 3. ElastiCache Improvements
- AUTH to RBAC migration fixes
- Valkey engine support
- Better serverless cache handling

## Breaking Changes

### 1. Resource Explorer IDs
```hcl
# Before (v5)
output "index_id" {
  value = aws_resourceexplorer2_index.example.id
}

# After (v6)
output "index_id" {
  value = aws_resourceexplorer2_index.example.arn  # Use arn instead
}
```

### 2. NAT Gateway Subnet
```hcl
# Before (v5) - Required
resource "aws_vpc_nat_gateway" "example" {
  subnet_id     = aws_subnet.public.id  # Required
  allocation_id = aws_eip.nat.id
}

# After (v6) - Optional for regional NAT
resource "aws_vpc_nat_gateway" "regional" {
  vpc_id            = aws_vpc.main.id  # For regional NAT
  availability_mode = "regional"
  # subnet_id is optional now
}
```

### 3. IAM Permissions
Add new permission for regional NAT Gateways:
```json
{
  "Effect": "Allow",
  "Action": [
    "ec2:DescribeAvailabilityZones"
  ],
  "Resource": "*"
}
```

## Migration Steps

### Step 1: Backup
```bash
# Backup state file
terraform state pull > state-backup-$(date +%Y%m%d).tfstate

# Backup configuration
cp -r vpc-prod vpc-prod-backup
```

### Step 2: Update Provider
```hcl
# provider.tf
terraform {
  required_version = ">= 1.10.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31"  # Updated
    }
  }
}
```

### Step 3: Test in Non-Prod
```bash
cd vpc-nonprod
terraform init -upgrade
terraform plan
# Review changes carefully
terraform apply
```

### Step 4: Update Production
```bash
cd vpc-prod
terraform init -upgrade
terraform plan > upgrade-plan.txt
# Review plan thoroughly
terraform apply
```

## Cost Optimization with Regional NAT

Regional NAT Gateways can reduce costs:

```hcl
# New regional NAT (v6.31+)
resource "aws_vpc_nat_gateway" "regional" {
  vpc_id            = aws_vpc.main.id
  availability_mode = "regional"
  auto_provision_zones = true
  auto_scaling_ips     = true
  
  tags = {
    Name     = "regional-nat"
    CostNote = "Single regional NAT vs 2 zonal NATs = ~$32/month savings"
  }
}
```

**Savings**: ~$32/month vs 2 zonal NAT Gateways

## Rollback Plan

If issues occur:

```bash
# 1. Restore provider version
# Edit provider.tf back to ~> 5.100

# 2. Reinitialize
terraform init -upgrade

# 3. Restore state if needed
terraform state push state-backup-YYYYMMDD.tfstate

# 4. Apply
terraform apply
```

## Testing Checklist

- [ ] Backup state files
- [ ] Update provider version
- [ ] Run `terraform init -upgrade`
- [ ] Review `terraform plan` output
- [ ] Check for deprecated resources
- [ ] Test in non-prod first
- [ ] Verify NAT Gateway connectivity
- [ ] Check Lambda functions
- [ ] Monitor CloudWatch logs
- [ ] Validate cost impact
- [ ] Update documentation
- [ ] Train team on changes

## Timeline Recommendation

- **Week 1**: Review changes, backup everything
- **Week 2**: Test in development environment
- **Week 3**: Test in staging environment
- **Week 4**: Deploy to production (if all tests pass)

## Support

If you encounter issues:
1. Check [AWS Provider Changelog](https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md)
2. Review [GitHub Issues](https://github.com/hashicorp/terraform-provider-aws/issues)
3. Consult [HashiCorp Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Conclusion

**Current Recommendation**: Stay on v5.100 for now, plan v6.31 upgrade for Q2 2026 after more stability testing in the community.
