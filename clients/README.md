# Client VPC Infrastructure Setup

Multi-client infrastructure management with separate production and non-production environments.

## Directory Structure

```
clients/
├── client-template/          # Template for new clients
│   ├── prod/                # Production environment
│   └── nonprod/             # Non-production environment
├── acme-corp/               # Example: ACME Corporation
│   ├── prod/
│   └── nonprod/
├── globex-inc/              # Example: Globex Inc
│   ├── prod/
│   └── nonprod/
└── README.md
```

## Quick Start for New Client

### 1. Copy Template
```bash
# Replace 'newclient' with actual client name (lowercase, no spaces)
cp -r clients/client-template clients/newclient
```

### 2. Configure Production
```bash
cd clients/newclient/prod
# Edit terraform.tfvars with client-specific values
terraform init
terraform plan
terraform apply
```

### 3. Configure Non-Production
```bash
cd clients/newclient/nonprod
# Edit terraform.tfvars with client-specific values
terraform init
terraform plan
terraform apply
```

## Pre-Requisites

Before starting, send the pre-requisites email to the client:
- See `PRE-REQUISITES-EMAIL.md` for template
- Collect all required information
- Verify AWS account access

## Client Naming Convention

- Use lowercase
- No spaces (use hyphens)
- Examples: `acme-corp`, `globex-inc`, `initech-llc`

## Environment Separation

### Production
- CIDR: 10.X.0.0/16 (where X = client number * 10)
- 2 NAT Gateways (HA)
- 90-day Flow Log retention
- Full monitoring enabled

### Non-Production
- CIDR: 10.X.1.0/16 (where X = client number * 10 + 1)
- 1 NAT Gateway (cost optimized)
- 7-day Flow Log retention
- Basic monitoring

## CIDR Allocation

| Client | Production CIDR | Non-Prod CIDR |
|--------|----------------|---------------|
| Client 1 | 10.10.0.0/16 | 10.11.0.0/16 |
| Client 2 | 10.20.0.0/16 | 10.21.0.0/16 |
| Client 3 | 10.30.0.0/16 | 10.31.0.0/16 |
| Client 4 | 10.40.0.0/16 | 10.41.0.0/16 |

## Cost Estimates

### Per Client Monthly Cost

| Environment | NAT GWs | Base Cost | Notes |
|-------------|---------|-----------|-------|
| Production  | 2       | ~$70      | Full HA |
| Non-Prod    | 1       | ~$34      | Cost optimized |
| **Total**   | 3       | **~$104** | Per client |

## Management

### List All Clients
```bash
ls -d clients/*/
```

### Deploy All Environments for a Client
```bash
./scripts/deploy-client.sh client-name
```

### Destroy Client Infrastructure
```bash
./scripts/destroy-client.sh client-name
```

## Best Practices

1. **Always deploy non-prod first** - Test before production
2. **Use separate AWS accounts** - Isolate client environments
3. **Tag everything** - Enable cost tracking per client
4. **Document changes** - Keep client-specific notes
5. **Regular backups** - State files and configurations
6. **Monitor costs** - Set up billing alerts per client

## Support

For issues or questions, refer to:
- `TFVARS-GUIDE.md` - Variable configuration
- `DEPLOYMENT.md` - Deployment procedures
- `VERSION.md` - Version information
