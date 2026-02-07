# AWS VPC Infrastructure Setup - Pre-Requisites

**Email Template for Client Onboarding**

---

**Subject:** AWS VPC Infrastructure Setup - Information Required

**To:** [Client Contact Name]  
**From:** [Your Name/Team]  
**Date:** [Current Date]

---

Dear [Client Name],

We're ready to begin setting up your AWS VPC infrastructure for both production and non-production environments. To proceed, we need the following information from your team.

## 1. AWS Account Information

### Production Environment
- [ ] AWS Account ID: ___________________________
- [ ] AWS Region: ___________________________
- [ ] IAM Access Method:
  - [ ] IAM User (Access Key + Secret Key)
  - [ ] IAM Role ARN
  - [ ] AWS SSO

### Non-Production Environment
- [ ] AWS Account ID: ___________________________
- [ ] AWS Region: ___________________________
- [ ] Same as production? [ ] Yes [ ] No

**Note:** We strongly recommend using separate AWS accounts for production and non-production environments.

---

## 2. Project Information

- [ ] Project Name: ___________________________
- [ ] Environment Names:
  - Production: ___________________________
  - Non-Production: ___________________________
- [ ] Cost Center/Department: ___________________________
- [ ] Technical Owner Name: ___________________________
- [ ] Technical Owner Email: ___________________________

---

## 3. Network Configuration

### IP Address Ranges (CIDR Blocks)

**Production VPC:**
- [ ] VPC CIDR Block: ___________________________ (Recommended: 10.X.0.0/16)
- [ ] Any existing networks to avoid overlap? [ ] Yes [ ] No
  - If yes, please list: ___________________________

**Non-Production VPC:**
- [ ] VPC CIDR Block: ___________________________ (Recommended: 10.X.1.0/16)

**Note:** If unsure, we can suggest CIDR blocks based on your requirements.

---

## 4. High Availability Requirements

### Production Environment
- [ ] Multi-AZ deployment required? [ ] Yes [ ] No
- [ ] Number of Availability Zones: [ ] 2 [ ] 3
- [ ] Redundant NAT Gateways? [ ] Yes (Recommended) [ ] No

### Non-Production Environment
- [ ] Multi-AZ deployment required? [ ] Yes [ ] No
- [ ] Single NAT Gateway acceptable? [ ] Yes (Cost savings) [ ] No

---

## 5. Connectivity Requirements

- [ ] VPN Connection to On-Premises? [ ] Yes [ ] No
  - If yes, provide:
    - On-premises public IP: ___________________________
    - BGP ASN: ___________________________
    - VPN Type: [ ] Site-to-Site [ ] Client VPN

- [ ] AWS Direct Connect? [ ] Yes [ ] No
  - If yes, provide connection details: ___________________________

- [ ] VPC Peering with other VPCs? [ ] Yes [ ] No
  - If yes, list VPC IDs: ___________________________

---

## 6. Security & Compliance

- [ ] Industry compliance requirements:
  - [ ] HIPAA
  - [ ] PCI-DSS
  - [ ] SOC 2
  - [ ] GDPR
  - [ ] Other: ___________________________

- [ ] VPC Flow Logs required? [ ] Yes (Recommended) [ ] No
  - Retention period: [ ] 7 days [ ] 30 days [ ] 90 days

- [ ] Encryption requirements:
  - [ ] Data at rest
  - [ ] Data in transit
  - [ ] KMS key management

---

## 7. Monitoring & Alerting

- [ ] CloudWatch monitoring required? [ ] Yes [ ] No
- [ ] Cost alerts required? [ ] Yes [ ] No
  - If yes, monthly budget threshold: $___________________________
- [ ] Alert notification email(s): ___________________________
- [ ] Slack/Teams webhook for alerts? [ ] Yes [ ] No
  - If yes, provide webhook URL: ___________________________

---

## 8. Backup & Disaster Recovery

- [ ] Backup requirements:
  - [ ] Daily
  - [ ] Weekly
  - [ ] Monthly
  - Retention period: ___________________________ days

- [ ] Disaster Recovery:
  - RTO (Recovery Time Objective): ___________________________ hours
  - RPO (Recovery Point Objective): ___________________________ hours
  - Multi-region deployment? [ ] Yes [ ] No

---

## 9. Cost Optimization Preferences

- [ ] Budget constraints: $___________________________/month
- [ ] Cost optimization priority:
  - [ ] High (maximize savings, accept some limitations)
  - [ ] Medium (balance cost and performance)
  - [ ] Low (prioritize performance and availability)

- [ ] Acceptable cost-saving measures:
  - [ ] Single NAT Gateway in non-prod
  - [ ] Shorter log retention in non-prod
  - [ ] Disable monitoring in non-prod
  - [ ] Auto-shutdown for non-prod resources

---

## 10. Access & Permissions

### IAM Permissions Required

We need the following IAM permissions to deploy the infrastructure:

**Required Services:**
- VPC (Full access)
- EC2 (Subnets, Route Tables, NAT Gateways, Internet Gateways)
- CloudWatch (Logs, Alarms)
- IAM (Role creation for Flow Logs)
- S3 (For Terraform state - optional)

**Recommended IAM Policy:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "vpc:*",
        "logs:*",
        "cloudwatch:*",
        "iam:CreateRole",
        "iam:PutRolePolicy",
        "iam:AttachRolePolicy",
        "iam:PassRole"
      ],
      "Resource": "*"
    }
  ]
}
```

- [ ] IAM permissions configured? [ ] Yes [ ] No
- [ ] MFA required for deployment? [ ] Yes [ ] No

---

## 11. Deployment Timeline

- [ ] Preferred deployment date: ___________________________
- [ ] Maintenance window (if applicable):
  - Day: ___________________________
  - Time: ___________________________ (Timezone: ___________)
  - Duration: ___________________________ hours

- [ ] Go-live date: ___________________________

---

## 12. Additional Requirements

Please list any additional requirements or special considerations:

_______________________________________________________________
_______________________________________________________________
_______________________________________________________________
_______________________________________________________________

---

## 13. Documentation & Training

- [ ] Infrastructure documentation required? [ ] Yes [ ] No
- [ ] Team training required? [ ] Yes [ ] No
  - Number of team members: ___________________________
  - Preferred training format: [ ] Live session [ ] Recorded [ ] Documentation

---

## Next Steps

Once we receive this information:

1. **Day 1-2:** Review and validate all information
2. **Day 3-4:** Prepare infrastructure code and configurations
3. **Day 5:** Deploy non-production environment
4. **Day 6-7:** Testing and validation
5. **Day 8:** Deploy production environment (with your approval)
6. **Day 9-10:** Handover and documentation

**Estimated Timeline:** 10 business days from information receipt

---

## Cost Estimate

Based on standard configuration:

| Environment | Monthly Cost | Annual Cost |
|-------------|--------------|-------------|
| Production  | ~$70         | ~$840       |
| Non-Prod    | ~$34         | ~$408       |
| **Total**   | **~$104**    | **~$1,248** |

**Note:** This is for networking infrastructure only. Actual costs may vary based on:
- Data transfer volumes
- Additional services
- Custom requirements

---

## Contact Information

If you have any questions or need clarification, please contact:

**Technical Lead:** [Your Name]  
**Email:** [Your Email]  
**Phone:** [Your Phone]  
**Slack/Teams:** [Your Handle]

**Office Hours:** [Your Hours]  
**Emergency Contact:** [Emergency Number]

---

## Attachments

Please find attached:
1. Architecture diagram (PDF)
2. Cost breakdown spreadsheet (Excel)
3. Security compliance checklist (PDF)
4. Sample IAM policy (JSON)

---

Please complete this form and return it by **[Deadline Date]** to ensure we meet your deployment timeline.

We look forward to working with you!

Best regards,

[Your Name]  
[Your Title]  
[Your Company]  
[Contact Information]

---

**Confidentiality Notice:** This email and any attachments are confidential and intended solely for the addressee. If you are not the intended recipient, please delete this email and notify the sender immediately.
