# Client Infrastructure Template

Template for deploying client-specific VPC infrastructure.

## Setup Instructions

### 1. Copy Template for New Client

```bash
# From project root
cp -r clients/client-template clients/[client-name]
cd clients/[client-name]
```

### 2. Configure Production Environment

```bash
cd prod

# Copy and edit configuration
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with client-specific values

# Initialize and deploy
terraform init
terraform plan
terraform apply
```

### 3. Configure Non-Production Environment

```bash
cd ../nonprod

# Copy and edit configuration
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with client-specific values

# Initialize and deploy
terraform init
terraform plan
terraform apply
```

## Configuration Checklist

### Before Deployment

- [ ] Received completed pre-requisites form
- [ ] AWS account access verified
- [ ] CIDR blocks assigned (no overlaps)
- [ ] IAM permissions configured
- [ ] Cost budget approved
- [ ] Deployment window scheduled

### Production Environment

- [ ] terraform.tfvars configured
- [ ] Client name updated
- [ ] CIDR blocks set (10.X.0.0/16)
- [ ] 2 NAT Gateways enabled
- [ ] Flow logs enabled (90 days)
- [ ] CloudWatch alarms enabled
- [ ] Tags configured

### Non-Production Environment

- [ ] terraform.tfvars configured
- [ ] Client name updated
- [ ] CIDR blocks set (10.X.1.0/16)
- [ ] 1 NAT Gateway enabled
- [ ] Flow logs enabled (7 days)
- [ ] CloudWatch alarms enabled
- [ ] Tags configured

## Client-Specific Values

Update these in both prod and nonprod terraform.tfvars:

```hcl
# Client Information
project_name = "client-name"
cost_center  = "client-cost-center"
owner        = "client-team"

# Network Configuration
vpc_cidr = "10.X.0.0/16"  # Prod: 10.X.0.0/16, NonProd: 10.X.1.0/16

# Tags
additional_tags = {
  Client      = "Client Name"
  BillingCode = "CLIENT-001"
  Contact     = "client@example.com"
}
```

## Deployment Commands

### Production
```bash
cd prod
terraform init
terraform plan -out=prod.tfplan
terraform apply prod.tfplan
```

### Non-Production
```bash
cd nonprod
terraform init
terraform plan -out=nonprod.tfplan
terraform apply nonprod.tfplan
```

## Validation

After deployment, verify:

```bash
# Check VPC
terraform output vpc_id

# Check subnets
terraform output web_subnet_ids
terraform output app_subnet_ids
terraform output db_subnet_ids

# Check NAT Gateways
terraform output nat_gateway_ids

# Check cost estimate
terraform output monthly_cost_estimate
```

## Cleanup

To destroy infrastructure:

```bash
# Non-production first
cd nonprod
terraform destroy

# Then production
cd ../prod
terraform destroy
```

## Support

For issues, refer to:
- Main README.md
- TFVARS-GUIDE.md
- DEPLOYMENT.md
