
# Client Onboarding Checklist

Complete checklist for onboarding new clients with AWS VPC infrastructure.

## Phase 1: Pre-Sales & Discovery

### Initial Contact
- [ ] Client name and contact information collected
- [ ] Business requirements documented
- [ ] Technical requirements documented
- [ ] Budget discussed and approved
- [ ] Timeline agreed upon

### Pre-Requisites Email
- [ ] Send PRE-REQUISITES-EMAIL.md to client
- [ ] Set deadline for response (typically 5 business days)
- [ ] Schedule follow-up call to review responses

## Phase 2: Information Gathering

### AWS Account Information
- [ ] Production AWS Account ID received
- [ ] Non-Production AWS Account ID received
- [ ] AWS Region(s) confirmed
- [ ] IAM access method determined
- [ ] Access credentials received (securely)

### Project Details
- [ ] Project name finalized
- [ ] Cost center/billing code assigned
- [ ] Technical owner identified
- [ ] Emergency contact information collected

### Network Configuration
- [ ] CIDR blocks assigned (no overlaps)
  - Production: 10.X.0.0/16
  - Non-Prod: 10.X.1.0/16
- [ ] Existing network infrastructure documented
- [ ] VPN/Direct Connect requirements identified
- [ ] VPC peering requirements identified

### Security & Compliance
- [ ] Compliance requirements documented
- [ ] Security policies reviewed
- [ ] Encryption requirements confirmed
- [ ] Access control requirements defined

## Phase 3: Setup & Configuration

### Client Directory Setup
- [ ] Create client directory from template
  ```bash
  cp -r clients/client-template clients/[client-name]
  ```
- [ ] Update README.md with client-specific information
- [ ] Assign client number for CIDR allocation

### Production Environment Configuration
- [ ] Copy terraform.tfvars.example to terraform.tfvars
- [ ] Update project_name
- [ ] Configure vpc_cidr (10.X.0.0/16)
- [ ] Configure subnet CIDRs
- [ ] Set environment = "production"
- [ ] Enable 2 NAT Gateways (single_nat_gateway = false)
- [ ] Set flow_logs_retention_days = 90
- [ ] Configure cost_center and owner
- [ ] Add client-specific tags
- [ ] Review and validate all settings

### Non-Production Environment Configuration
- [ ] Copy terraform.tfvars.example to terraform.tfvars
- [ ] Update project_name
- [ ] Configure vpc_cidr (10.X.1.0/16)
- [ ] Configure subnet CIDRs
- [ ] Set environment = "staging" or "development"
- [ ] Enable 1 NAT Gateway (single_nat_gateway = true)
- [ ] Set flow_logs_retention_days = 7
- [ ] Configure cost_center and owner
- [ ] Add client-specific tags
- [ ] Review and validate all settings

## Phase 4: Validation & Testing

### Pre-Deployment Validation
- [ ] Run terraform fmt on all files
- [ ] Run terraform validate on prod environment
- [ ] Run terraform validate on nonprod environment
- [ ] Review terraform plan output for prod
- [ ] Review terraform plan output for nonprod
- [ ] Verify CIDR blocks don't overlap with existing infrastructure
- [ ] Confirm IAM permissions are sufficient
- [ ] Review cost estimates with client

### Security Review
- [ ] Security groups configured correctly
- [ ] NACLs reviewed (if custom)
- [ ] VPC Flow Logs enabled
- [ ] CloudWatch alarms configured
- [ ] IAM roles follow least privilege principle

## Phase 5: Deployment

### Non-Production Deployment
- [ ] Schedule deployment window with client
- [ ] Backup any existing state files
- [ ] Run terraform init
- [ ] Run terraform plan -out=nonprod.tfplan
- [ ] Review plan with client (if required)
- [ ] Run terraform apply nonprod.tfplan
- [ ] Verify deployment successful
- [ ] Test connectivity
- [ ] Verify monitoring and logging
- [ ] Document any issues

### Production Deployment
- [ ] Schedule deployment window with client
- [ ] Ensure non-prod is stable
- [ ] Backup any existing state files
- [ ] Run terraform init
- [ ] Run terraform plan -out=prod.tfplan
- [ ] Review plan with client
- [ ] Get client approval
- [ ] Run terraform apply prod.tfplan
- [ ] Verify deployment successful
- [ ] Test connectivity
- [ ] Verify monitoring and logging
- [ ] Document any issues

## Phase 6: Post-Deployment

### Verification
- [ ] VPC created successfully
- [ ] All subnets created (web, app, db)
- [ ] Internet Gateway attached
- [ ] NAT Gateway(s) operational
- [ ] Route tables configured correctly
- [ ] VPC Endpoints created
- [ ] Flow Logs streaming to CloudWatch
- [ ] CloudWatch alarms active
- [ ] Tags applied correctly

### Testing
- [ ] Launch test EC2 instance in public subnet
- [ ] Verify internet connectivity from public subnet
- [ ] Launch test EC2 instance in private subnet
- [ ] Verify outbound internet via NAT Gateway
- [ ] Test VPC Endpoints (S3, DynamoDB)
- [ ] Verify DNS resolution
- [ ] Test security group rules
- [ ] Verify monitoring and alerting

### Documentation
- [ ] Create client-specific documentation
- [ ] Document VPC IDs and subnet IDs
- [ ] Document NAT Gateway IDs
- [ ] Create network diagram
- [ ] Document any custom configurations
- [ ] Create runbook for common operations
- [ ] Document backup and recovery procedures

## Phase 7: Handover

### Client Training
- [ ] Schedule training session
- [ ] Provide access to documentation
- [ ] Walk through AWS Console
- [ ] Demonstrate monitoring dashboards
- [ ] Explain cost management
- [ ] Review security best practices
- [ ] Answer client questions

### Access & Credentials
- [ ] Provide Terraform state file location
- [ ] Share documentation repository access
- [ ] Configure client access to monitoring
- [ ] Set up billing alerts
- [ ] Configure notification channels

### Support Setup
- [ ] Define support SLA
- [ ] Provide support contact information
- [ ] Set up ticketing system access
- [ ] Schedule regular check-ins
- [ ] Establish escalation procedures

## Phase 8: Ongoing Management

### First Week
- [ ] Monitor for any issues
- [ ] Review CloudWatch metrics
- [ ] Check cost reports
- [ ] Follow up with client
- [ ] Address any concerns

### First Month
- [ ] Review monthly costs
- [ ] Analyze usage patterns
- [ ] Optimize if needed
- [ ] Client satisfaction survey
- [ ] Schedule monthly review meeting

### Quarterly
- [ ] Review infrastructure
- [ ] Check for updates
- [ ] Security audit
- [ ] Cost optimization review
- [ ] Capacity planning

## Checklist Summary

### Critical Items (Must Complete)
1. Pre-requisites email sent and completed
2. AWS account access verified
3. CIDR blocks assigned (no overlaps)
4. Both environments configured
5. Non-prod deployed and tested
6. Production deployed and tested
7. Client training completed
8. Documentation provided

### Timeline
- **Day 1-2:** Information gathering
- **Day 3-4:** Configuration and validation
- **Day 5:** Non-prod deployment
- **Day 6-7:** Testing and fixes
- **Day 8:** Production deployment
- **Day 9-10:** Handover and training

**Total:** 10 business days

## Sign-Off

### Client Approval
- [ ] Client reviewed and approved configuration
- [ ] Client tested non-production environment
- [ ] Client approved production deployment
- [ ] Client received and reviewed documentation
- [ ] Client completed training

**Client Name:** ___________________________  
**Client Signature:** ___________________________  
**Date:** ___________________________

### Internal Approval
- [ ] Technical lead reviewed configuration
- [ ] Security team approved
- [ ] Finance approved budget
- [ ] Management approved deployment

**Technical Lead:** ___________________________  
**Date:** ___________________________

---

## Notes

Use this section for client-specific notes:

_______________________________________________________________
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________

---

**Last Updated:** February 7, 2026
