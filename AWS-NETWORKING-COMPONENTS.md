# Complete AWS Networking Components Guide

## Core Networking Services

### 1. Amazon VPC (Virtual Private Cloud)
**Purpose**: Isolated virtual network in AWS cloud

**Components**:
- IPv4/IPv6 CIDR blocks
- Subnets (public/private)
- Route tables
- Internet Gateway (IGW)
- NAT Gateway/NAT Instance
- Egress-only Internet Gateway (IPv6)
- VPC Peering
- VPC Endpoints (Gateway & Interface)
- DHCP Options Sets
- DNS resolution

**Use Cases**:
- Network isolation
- Multi-tier applications
- Hybrid cloud connectivity

**Cost**: Free (except NAT Gateway, VPC Endpoints)

---

### 2. Subnets
**Purpose**: Segment VPC into smaller networks

**Types**:
- **Public Subnet**: Routes to Internet Gateway
- **Private Subnet**: No direct internet access
- **Isolated Subnet**: No route to internet

**Best Practices**:
- Spread across multiple AZs
- Use /24 or larger CIDR blocks
- Reserve IP addresses for AWS services

---

### 3. Internet Gateway (IGW)
**Purpose**: Enable internet access for VPC

**Features**:
- Horizontally scaled
- Redundant
- Highly available
- No bandwidth constraints

**Cost**: Free

---

### 4. NAT Gateway
**Purpose**: Enable outbound internet for private subnets

**Types**:
- **Public NAT Gateway**: Standard (per AZ)
- **Private NAT Gateway**: For VPC-to-VPC
- **Regional NAT Gateway**: Auto multi-AZ (v6.31+)

**Cost**: 
- ~$32/month per NAT Gateway
- $0.045/GB data processed

**Alternatives**:
- NAT Instance (cheaper, less reliable)
- VPC Endpoints (free for S3/DynamoDB)

---

### 5. Route Tables
**Purpose**: Control traffic routing

**Types**:
- Main route table (default)
- Custom route tables
- Gateway route tables
- Local gateway route tables

**Routes**:
- Local (VPC CIDR)
- Internet Gateway
- NAT Gateway
- VPC Peering
- Transit Gateway
- VPN Gateway

---

### 6. VPC Endpoints
**Purpose**: Private connectivity to AWS services

**Types**:

#### Gateway Endpoints (Free)
- Amazon S3
- DynamoDB

#### Interface Endpoints (Paid)
- EC2, ECS, ECR
- Lambda, API Gateway
- Systems Manager (SSM)
- Secrets Manager
- CloudWatch
- SNS, SQS, Kinesis
- And 100+ more services

**Cost**: 
- Gateway: Free
- Interface: $0.01/hour per AZ (~$7.20/month)
- Data processing: $0.01/GB

**Savings**: Avoid NAT Gateway charges ($0.045/GB)

---

## Load Balancing

### 7. Elastic Load Balancer (ELB)

#### Application Load Balancer (ALB)
- **Layer**: 7 (HTTP/HTTPS)
- **Features**: Path/host routing, WebSocket, HTTP/2
- **Cost**: ~$16/month + $0.008/LCU-hour

#### Network Load Balancer (NLB)
- **Layer**: 4 (TCP/UDP/TLS)
- **Features**: Ultra-low latency, static IP, PrivateLink
- **Cost**: ~$16/month + $0.006/NLCU-hour

#### Gateway Load Balancer (GWLB)
- **Layer**: 3 (Network)
- **Features**: Third-party appliances, transparent proxy
- **Cost**: ~$16/month + $0.004/GLCU-hour

#### Classic Load Balancer (CLB)
- **Status**: Legacy (not recommended)
- **Layer**: 4 & 7

---

## DNS & Content Delivery

### 8. Amazon Route 53
**Purpose**: DNS web service

**Features**:
- Domain registration
- DNS routing
- Health checks
- Traffic policies
- DNSSEC

**Routing Policies**:
- Simple
- Weighted
- Latency-based
- Failover
- Geolocation
- Geoproximity
- Multi-value answer

**Cost**: 
- Hosted zone: $0.50/month
- Queries: $0.40/million (first 1B)

---

### 9. Amazon CloudFront
**Purpose**: Content Delivery Network (CDN)

**Features**:
- Global edge locations (400+)
- SSL/TLS support
- Custom SSL certificates
- Lambda@Edge
- Real-time logs
- Field-level encryption

**Cost**: 
- Data transfer: $0.085/GB (varies by region)
- Requests: $0.0075/10,000 (HTTP)

---

## Connectivity

### 10. AWS Direct Connect
**Purpose**: Dedicated network connection to AWS

**Features**:
- 1 Gbps, 10 Gbps, 100 Gbps
- Consistent network performance
- Reduced bandwidth costs
- Private connectivity

**Cost**: 
- Port hours: $0.30/hour (1 Gbps)
- Data transfer out: Reduced rates

---

### 11. AWS VPN

#### Site-to-Site VPN
- Connect on-premises to AWS
- IPsec tunnels
- Redundant connections
- **Cost**: $0.05/hour per connection

#### Client VPN
- Remote user access
- OpenVPN-based
- **Cost**: $0.10/hour per connection + $0.05/hour per user

---

### 12. AWS Transit Gateway
**Purpose**: Central hub for VPC and on-premises connectivity

**Features**:
- Connect thousands of VPCs
- Centralized routing
- Multicast support
- Inter-region peering

**Cost**: 
- Attachment: $0.05/hour
- Data processing: $0.02/GB

---

### 13. AWS PrivateLink
**Purpose**: Private connectivity to services

**Features**:
- No internet gateway needed
- No NAT required
- Powered by NLB
- Cross-account access

**Cost**: 
- Endpoint: $0.01/hour per AZ
- Data processing: $0.01/GB

---

## Security

### 14. Security Groups
**Purpose**: Virtual firewall for instances

**Features**:
- Stateful
- Allow rules only
- Instance-level
- Multiple per instance

**Best Practices**:
- Least privilege
- Use descriptive names
- Reference other security groups

---

### 15. Network ACLs (NACLs)
**Purpose**: Subnet-level firewall

**Features**:
- Stateless
- Allow and deny rules
- Numbered rules (evaluated in order)
- Subnet-level

**Default**: Allow all traffic

---

### 16. AWS WAF (Web Application Firewall)
**Purpose**: Protect web applications

**Features**:
- SQL injection protection
- XSS protection
- Rate limiting
- Geo-blocking
- Custom rules

**Cost**: 
- Web ACL: $5/month
- Rules: $1/month per rule
- Requests: $0.60/million

---

### 17. AWS Shield
**Purpose**: DDoS protection

**Tiers**:
- **Standard**: Free, automatic
- **Advanced**: $3,000/month + data transfer

---

### 18. AWS Firewall Manager
**Purpose**: Centralized firewall management

**Features**:
- Manage WAF rules
- Security groups
- Network ACLs
- Shield Advanced

**Cost**: 
- Policy: $100/month
- Resources: $0.10/resource/month

---

## Monitoring & Troubleshooting

### 19. VPC Flow Logs
**Purpose**: Capture IP traffic information

**Destinations**:
- CloudWatch Logs
- S3
- Kinesis Data Firehose

**Cost**: 
- CloudWatch: $0.50/GB ingested
- S3: Storage costs only

---

### 20. VPC Traffic Mirroring
**Purpose**: Copy network traffic for analysis

**Use Cases**:
- Security monitoring
- Troubleshooting
- Compliance

**Cost**: 
- Mirror session: $0.015/hour
- Data transfer charges apply

---

### 21. VPC Reachability Analyzer
**Purpose**: Network path analysis

**Features**:
- Verify connectivity
- Identify misconfigurations
- No packet sending

**Cost**: $0.10 per analysis

---

### 22. Network Access Analyzer
**Purpose**: Identify unintended network access

**Features**:
- Compliance verification
- Security posture assessment
- Automated analysis

**Cost**: Free

---

## Advanced Networking

### 23. AWS Global Accelerator
**Purpose**: Improve application availability and performance

**Features**:
- Static anycast IPs
- Global traffic management
- Health checks
- DDoS protection (Shield)

**Cost**: 
- Fixed fee: $0.025/hour
- Data transfer: $0.015/GB

---

### 24. AWS App Mesh
**Purpose**: Service mesh for microservices

**Features**:
- Traffic management
- Observability
- Security (mTLS)
- Works with ECS, EKS, EC2

**Cost**: Free (pay for underlying resources)

---

### 25. AWS Cloud Map
**Purpose**: Service discovery

**Features**:
- DNS-based discovery
- API-based discovery
- Health checks
- Custom attributes

**Cost**: 
- Namespace: $0.50/month
- Queries: $0.40/million

---

### 26. Elastic Network Interface (ENI)
**Purpose**: Virtual network card

**Features**:
- Multiple per instance
- Persistent
- Movable between instances
- Multiple IP addresses

**Cost**: Free

---

### 27. Elastic IP (EIP)
**Purpose**: Static public IPv4 address

**Features**:
- Persistent
- Remappable
- Associated with ENI

**Cost**: 
- Free when attached to running instance
- $0.005/hour when not attached

---

### 28. AWS Network Firewall
**Purpose**: Managed network firewall

**Features**:
- Stateful inspection
- IPS/IDS
- Domain filtering
- Custom rules

**Cost**: 
- Endpoint: $0.395/hour
- Data processing: $0.065/GB

---

### 29. VPC Lattice
**Purpose**: Application networking service

**Features**:
- Service-to-service connectivity
- Cross-VPC/account communication
- Built-in security
- Observability

**Cost**: 
- Service network: $0.025/hour
- Requests: $0.10/million

---

## Hybrid & Multi-Cloud

### 30. AWS Outposts
**Purpose**: AWS infrastructure on-premises

**Features**:
- Local VPC
- Local subnets
- Local gateways

---

### 31. AWS Wavelength
**Purpose**: 5G edge computing

**Features**:
- Ultra-low latency
- Wavelength Zones
- Mobile edge computing

---

### 32. AWS Local Zones
**Purpose**: Compute and storage closer to users

**Features**:
- Single-digit millisecond latency
- Extension of AWS Region
- Subset of services

---

## Cost Optimization Summary

| Component | Monthly Cost | Optimization |
|-----------|--------------|--------------|
| VPC | Free | - |
| Internet Gateway | Free | - |
| NAT Gateway | $32/each | Use VPC Endpoints |
| VPC Endpoint (Gateway) | Free | Always use for S3/DynamoDB |
| VPC Endpoint (Interface) | $7.20/AZ | Use for high-traffic services |
| ALB | $16+ | Right-size, use target groups |
| NLB | $16+ | Use for TCP/UDP only |
| Route 53 | $0.50/zone | Consolidate zones |
| CloudFront | Variable | Use caching effectively |
| Transit Gateway | $36/attachment | Consolidate connections |
| Direct Connect | $216+ | For consistent high bandwidth |

---

## Architecture Patterns

### 1. Basic Web Application
- VPC with public/private subnets
- ALB in public subnets
- EC2/ECS in private subnets
- RDS in isolated subnets
- NAT Gateway for outbound

### 2. Highly Available
- Multi-AZ deployment
- Multiple NAT Gateways
- Auto Scaling groups
- Multi-region with Route 53

### 3. Cost-Optimized
- Single NAT Gateway (non-prod)
- VPC Endpoints for AWS services
- CloudFront for static content
- S3 for storage

### 4. Hybrid Cloud
- Direct Connect or VPN
- Transit Gateway
- Route 53 Resolver
- Private connectivity

### 5. Microservices
- App Mesh or VPC Lattice
- Multiple VPCs with Transit Gateway
- PrivateLink for services
- Cloud Map for discovery

---

## Best Practices

1. **Design for HA**: Multi-AZ deployment
2. **Use VPC Endpoints**: Reduce NAT costs
3. **Implement Security Layers**: Security groups + NACLs
4. **Enable Flow Logs**: Security and troubleshooting
5. **Tag Everything**: Cost allocation and management
6. **Plan CIDR Carefully**: Avoid overlaps
7. **Use Transit Gateway**: For complex topologies
8. **Monitor Costs**: CloudWatch + Cost Explorer
9. **Automate with IaC**: Terraform, CloudFormation
10. **Regular Security Audits**: AWS Config, Security Hub

---

## Quick Reference

### Most Common Components
1. VPC
2. Subnets
3. Internet Gateway
4. NAT Gateway
5. Route Tables
6. Security Groups
7. VPC Endpoints
8. Load Balancers
9. Route 53
10. CloudFront

### Cost Drivers
1. NAT Gateway ($32/month + data)
2. Load Balancers ($16/month + usage)
3. Data Transfer (varies)
4. Direct Connect ($216+/month)
5. Transit Gateway ($36/attachment)

### Free Services
1. VPC
2. Internet Gateway
3. Security Groups
4. Network ACLs
5. VPC Peering (data transfer charged)
6. Gateway Endpoints (S3, DynamoDB)

---

**Last Updated**: February 7, 2026
