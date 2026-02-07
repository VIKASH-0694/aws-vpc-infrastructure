#!/bin/bash

# Deploy client infrastructure (both prod and nonprod)
# Usage: ./scripts/deploy-client.sh client-name

set -e

CLIENT_NAME=$1

if [ -z "$CLIENT_NAME" ]; then
    echo "Error: Client name required"
    echo "Usage: ./scripts/deploy-client.sh client-name"
    exit 1
fi

CLIENT_DIR="clients/$CLIENT_NAME"

if [ ! -d "$CLIENT_DIR" ]; then
    echo "Error: Client directory not found: $CLIENT_DIR"
    echo "Create it first: cp -r clients/client-template clients/$CLIENT_NAME"
    exit 1
fi

echo "=========================================="
echo "Deploying infrastructure for: $CLIENT_NAME"
echo "=========================================="

# Deploy Non-Production first
echo ""
echo "Step 1: Deploying Non-Production Environment"
echo "--------------------------------------------"
cd "$CLIENT_DIR/nonprod"

if [ ! -f "terraform.tfvars" ]; then
    echo "Error: terraform.tfvars not found in nonprod/"
    echo "Copy from terraform.tfvars.example and configure"
    exit 1
fi

terraform init
terraform plan -out=nonprod.tfplan
echo ""
read -p "Apply non-production plan? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    terraform apply nonprod.tfplan
    echo "✓ Non-production environment deployed"
else
    echo "✗ Non-production deployment cancelled"
    exit 1
fi

# Deploy Production
echo ""
echo "Step 2: Deploying Production Environment"
echo "----------------------------------------"
cd "../prod"

if [ ! -f "terraform.tfvars" ]; then
    echo "Error: terraform.tfvars not found in prod/"
    echo "Copy from terraform.tfvars.example and configure"
    exit 1
fi

terraform init
terraform plan -out=prod.tfplan
echo ""
read -p "Apply production plan? (yes/no): " confirm
if [ "$confirm" = "yes" ]; then
    terraform apply prod.tfplan
    echo "✓ Production environment deployed"
else
    echo "✗ Production deployment cancelled"
    exit 1
fi

echo ""
echo "=========================================="
echo "Deployment Complete for: $CLIENT_NAME"
echo "=========================================="
echo ""
echo "Production VPC ID:"
terraform output vpc_id
echo ""
echo "Monthly Cost Estimate:"
terraform output monthly_cost_estimate
echo ""
