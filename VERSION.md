# Version Information - Latest Market Versions

## Current Latest Versions (February 2026)

### Terraform
- **Latest Stable**: v1.10.x (recommended for production)
- **Latest Alpha**: v1.15.0-alpha20260204 (experimental)
- **Recommended**: >= 1.9.0 for production use

### AWS Provider
- **Latest Version**: v6.31.0 (February 4, 2026)
- **Previous Major**: v5.x (stable)
- **Recommended**: ~> 6.31 for latest features

## What We're Using

### Current Configuration
- **Terraform**: >= 1.9.0
- **AWS Provider**: ~> 5.100

### Why Not v6.x Yet?
AWS Provider v6.x was released recently (Feb 2026) and includes:
- Breaking changes from v5.x
- New regional NAT Gateway features
- Enhanced Lambda configurations
- Updated ElastiCache features

**Recommendation**: Stay on v5.100+ for stability, upgrade to v6.x after testing.

## Latest Features in AWS Provider v6.31.0

### New NAT Gateway Features
- Regional NAT Gateways (multi-AZ automatic)
- Auto-scaling IPs
- Availability mode configuration
- Enhanced routing capabilities

### Lambda Enhancements
- Capacity provider configuration
- Enhanced publishing options

### ElastiCache Updates
- AUTH to RBAC migration fixes
- Serverless cache improvements
- Valkey engine support

## Upgrade Path

### Option 1: Stay Current (Recommended)
```hcl
terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"  # Stable, production-ready
    }
  }
}
```

### Option 2: Upgrade to Latest
```hcl
terraform {
  required_version = ">= 1.10.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.31"  # Latest features
    }
  }
}
```

## Breaking Changes in v6.x

1. **Resource ID Changes**
   - `aws_resourceexplorer2_index`: Use `arn` instead of `id`
   - `aws_resourceexplorer2_view`: Use `arn` instead of `id`

2. **NAT Gateway Changes**
   - `subnet_id` now optional (for regional NAT)
   - New required IAM permission: `ec2:DescribeAvailabilityZones`

3. **S3 Backend Changes**
   - Environment variables now require explicit `true`/`false` values

## Migration Guide

### Testing v6.x Upgrade
```bash
# 1. Backup state
terraform state pull > backup.tfstate

# 2. Update provider version
# Edit provider.tf to use ~> 6.31

# 3. Reinitialize
terraform init -upgrade

# 4. Check for changes
terraform plan

# 5. Review and apply
terraform apply
```

## Version Compatibility Matrix

| Terraform | AWS Provider | Status | Use Case |
|-----------|--------------|--------|----------|
| >= 1.9.0  | ~> 5.100     | ✅ Stable | Production (Current) |
| >= 1.10.0 | ~> 6.31      | ✅ Latest | New features |
| >= 1.8.0  | ~> 5.0       | ⚠️ Old   | Legacy |
| < 1.8.0   | < 5.0        | ❌ EOL   | Not recommended |

## Recommendations

### For Production
- **Terraform**: 1.9.x or 1.10.x
- **AWS Provider**: 5.100+ (stable) or 6.31+ (after testing)
- Test in non-prod first
- Review breaking changes

### For New Projects
- **Terraform**: Latest stable (1.10.x)
- **AWS Provider**: 6.31+ (latest features)
- Use regional NAT Gateways for cost savings
- Leverage new Lambda features

### For Existing Projects
- Stay on 5.100+ until v6.x is tested
- Plan migration during maintenance window
- Update documentation
- Train team on new features

## Update Schedule

- **Check for updates**: Monthly
- **Security patches**: Immediately
- **Major versions**: After 2-3 months of stability
- **Test in non-prod**: Always

## Resources

- [Terraform Releases](https://github.com/hashicorp/terraform/releases)
- [AWS Provider Releases](https://github.com/hashicorp/terraform-provider-aws/releases)
- [AWS Provider Changelog](https://github.com/hashicorp/terraform-provider-aws/blob/main/CHANGELOG.md)
- [Terraform Upgrade Guide](https://developer.hashicorp.com/terraform/language/upgrade-guides)

## Next Steps

1. Review current configuration (v5.100)
2. Test v6.31 in non-prod environment
3. Evaluate new regional NAT Gateway features
4. Plan migration timeline
5. Update documentation

---

**Last Updated**: February 7, 2026  
**Current Config**: Terraform >= 1.9.0, AWS Provider ~> 5.100  
**Latest Available**: Terraform 1.15.0-alpha, AWS Provider 6.31.0
