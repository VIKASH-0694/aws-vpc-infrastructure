# FinOps Best Practices for Production VPC

## Cost Optimization Strategies

### 1. NAT Gateway Optimization
- **Cost**: ~$32/month per NAT Gateway + $0.045/GB data processed
- **Production**: Use 2 NAT Gateways (one per AZ) for HA
- **Non-Production**: Set `single_nat_gateway = true` to save ~$32/month
- **Development**: Set `enable_nat_gateway = false` and use VPC endpoints only

### 2. VPC Endpoints (Gateway - Free)
- S3 Gateway Endpoint: Saves NAT Gateway data processing charges
- DynamoDB Gateway Endpoint: Saves NAT Gateway data processing charges
- **Savings**: $0.045/GB for all S3/DynamoDB traffic

### 3. VPC Endpoints (Interface - Paid)
- Consider for high-traffic AWS services (ECR, ECS, SSM, Secrets Manager)
- **Cost**: $0.01/hour per AZ (~$7.20/month per endpoint per AZ)
- **Break-even**: ~160GB/month of traffic per endpoint

### 4. Tagging Strategy for Cost Allocation
All resources tagged with:
- **Environment**: Track costs by environment (dev/staging/prod)
- **Project**: Allocate costs to specific projects
- **CostCenter**: Department or team billing
- **Owner**: Accountability and contact
- **ManagedBy**: Infrastructure management method

### 5. CloudWatch Monitoring
- NAT Gateway bandwidth alerts for cost anomalies
- S3 data transfer monitoring for VPC endpoint recommendations
- Flow logs retention: 90 days (prod), 7 days (non-prod)

### 6. Cost Comparison

#### High Availability (Production)
- 2 NAT Gateways: ~$64/month
- 2 EIPs: ~$0.24/month
- Data processing: $0.045/GB
- **Monthly Base**: ~$64.24

#### Single NAT Gateway (Staging)
- 1 NAT Gateway: ~$32/month
- 1 EIP: ~$0.12/month
- Data processing: $0.045/GB
- **Monthly Base**: ~$32.12
- **Savings**: ~$32/month (50% reduction)

#### No NAT Gateway (Development)
- VPC Endpoints only: $0
- **Savings**: ~$64/month vs HA setup

## Implementation

### Production Environment
```hcl
environment          = "production"
enable_nat_gateway   = true
single_nat_gateway   = false
enable_vpc_flow_logs = true
```

### Staging Environment
```hcl
environment          = "staging"
enable_nat_gateway   = true
single_nat_gateway   = true  # Cost savings
enable_vpc_flow_logs = true
```

### Development Environment
```hcl
environment          = "development"
enable_nat_gateway   = false  # Maximum cost savings
single_nat_gateway   = false
enable_vpc_flow_logs = false
```

## Monthly Cost Estimates

| Environment | NAT Gateways | Base Cost | Data (100GB) | Total  |
|-------------|--------------|-----------|--------------|--------|
| Production  | 2            | $64.24    | $4.50        | $68.74 |
| Staging     | 1            | $32.12    | $4.50        | $36.62 |
| Development | 0            | $0        | $0           | $0     |

## Recommendations

1. **Use VPC Endpoints**: Always enable S3 and DynamoDB gateway endpoints (free)
2. **Right-size NAT Gateways**: Use single NAT for non-prod environments
3. **Monitor Data Transfer**: Set up CloudWatch alarms for cost anomalies
4. **Tag Everything**: Enable cost allocation tags for accurate tracking
5. **Review Monthly**: Analyze AWS Cost Explorer for optimization opportunities
6. **Consider Interface Endpoints**: For services with >160GB/month traffic
