# Quick Start Guide - Client VPC Setup

Fast track guide for setting up new client infrastructure.

## Prerequisites

1. Terraform installed (>= 1.9.0)
2. AWS CLI configured
3. Client information collected (see PRE-REQUISITES-EMAIL.md)

## 5-Minute Setup

### Step 1: Create Client (1 min)

**Windows:**
```powershell
.\scripts\new-client.ps1 -ClientName "acme-corp" -ClientNumber 1
```

**Linux/Mac:**
```bash
./scripts/new-client.sh acme-corp 1
```

This creates:
- `clients/acme-corp/prod/` - Production environment
- `clients/acme-corp/nonprod/` - Non-production environment
- Auto-assigned CIDR blocks (10.10.0.0/16 and 10.11.0.0/16)

### Step 2: Configure (2 min)

Edit the generated terraform.tfvars files:

**Production:**
```bash
cd clients/acme-corp/prod
# Edit terraform.tfvars - update:
# - cost_center
# - owner
# - aws_region
# - additional_tags
```

**Non-Production:**
```bash
cd clients/acme-corp/nonprod
# Edit terraform.tfvars - same updates as prod
```

### Step 3: Deploy Non-Prod (1 min)

```bash
cd clients/acme-corp/nonprod
terraform init
terraform plan
terraform apply
```

### Step 4: Deploy Prod (1 min)

```bash
cd clients/acme-corp/prod
terraform init
terraform plan
terraform apply
```

## Done! 🎉

Your client now has:
- ✅ Production VPC with HA (2 NAT Gateways)
- ✅ Non-Production VPC (1 NAT Gateway)
- ✅ 3-tier architecture (Web, App, DB)
- ✅ VPC Flow Logs
- ✅ CloudWatch monitoring
- ✅ Cost optimization (VPC Endpoints)

## What You Get

### Production Environment
- VPC: 10.10.0.0/16
- Web Subnets: 10.10.1.0/24, 10.10.2.0/24 (public)
- App Subnets: 10.10.11.0/24, 10.10.12.0/24 (private)
- DB Subnets: 10.10.21.0/24, 10.10.22.0/24 (isolated)
- 2 NAT Gateways (HA)
- Cost: ~$70/month

### Non-Production Environment
- VPC: 10.11.0.0/16
- Web Subnets: 10.11.1.0/24, 10.11.2.0/24 (public)
- App Subnets: 10.11.11.0/24, 10.11.12.0/24 (private)
- DB Subnets: 10.11.21.0/24, 10.11.22.0/24 (isolated)
- 1 NAT Gateway (cost optimized)
- Cost: ~$34/month

**Total: ~$104/month per client**

## Next Steps

1. **Test Connectivity**
   ```bash
   # Launch test instances
   # Verify internet access
   # Test VPC endpoints
   ```

2. **Configure Monitoring**
   ```bash
   # Check CloudWatch dashboards
   # Verify Flow Logs
   # Set up billing alerts
   ```

3. **Documentation**
   - Save VPC IDs
   - Document subnet IDs
   - Create network diagram
   - Share with client

4. **Client Handover**
   - Schedule training session
   - Provide documentation
   - Set up support channels

## Common Commands

### View Outputs
```bash
terraform output
```

### Update Configuration
```bash
# Edit terraform.tfvars
terraform plan
terraform apply
```

### Destroy (if needed)
```bash
terraform destroy
```

## Multiple Clients

For each new client, increment the client number:

```powershell
# Client 1
.\scripts\new-client.ps1 -ClientName "acme-corp" -ClientNumber 1

# Client 2
.\scripts\new-client.ps1 -ClientName "globex-inc" -ClientNumber 2

# Client 3
.\scripts\new-client.ps1 -ClientName "initech-llc" -ClientNumber 3
```

CIDR blocks are automatically assigned:
- Client 1: 10.10.x.x / 10.11.x.x
- Client 2: 10.20.x.x / 10.21.x.x
- Client 3: 10.30.x.x / 10.31.x.x

## Troubleshooting

### Issue: CIDR Overlap
**Solution:** Use different client number or manually edit CIDR in terraform.tfvars

### Issue: AWS Permissions
**Solution:** Ensure IAM user/role has VPC, EC2, CloudWatch, and IAM permissions

### Issue: Terraform State
**Solution:** Configure remote state (S3 + DynamoDB) for team collaboration

## Support

- Full Documentation: See README.md
- Variables Guide: See TFVARS-GUIDE.md
- Deployment Guide: See DEPLOYMENT.md
- Client Onboarding: See CLIENT-ONBOARDING-CHECKLIST.md

---

**Ready to deploy? Start with Step 1!**
