#!/bin/bash

# Create new client from template
# Usage: ./scripts/new-client.sh client-name client-number

set -e

CLIENT_NAME=$1
CLIENT_NUMBER=$2

if [ -z "$CLIENT_NAME" ] || [ -z "$CLIENT_NUMBER" ]; then
    echo "Error: Client name and number required"
    echo "Usage: ./scripts/new-client.sh client-name client-number"
    echo "Example: ./scripts/new-client.sh acme-corp 1"
    exit 1
fi

CLIENT_DIR="clients/$CLIENT_NAME"

if [ -d "$CLIENT_DIR" ]; then
    echo "Error: Client directory already exists: $CLIENT_DIR"
    exit 1
fi

echo "=========================================="
echo "Creating new client: $CLIENT_NAME"
echo "Client number: $CLIENT_NUMBER"
echo "=========================================="

# Copy template
cp -r clients/client-template "$CLIENT_DIR"

# Calculate CIDR blocks
PROD_CIDR="10.$((CLIENT_NUMBER * 10)).0.0/16"
NONPROD_CIDR="10.$((CLIENT_NUMBER * 10 + 1)).0.0/16"

echo ""
echo "Assigned CIDR blocks:"
echo "  Production: $PROD_CIDR"
echo "  Non-Prod:   $NONPROD_CIDR"

# Update production tfvars
cd "$CLIENT_DIR/prod"
cp terraform.tfvars.example terraform.tfvars
sed -i "s/project_name         = \"myapp\"/project_name         = \"$CLIENT_NAME\"/" terraform.tfvars
sed -i "s/vpc_cidr             = \"10.0.0.0\/16\"/vpc_cidr             = \"$PROD_CIDR\"/" terraform.tfvars
sed -i "s/web_subnet_cidrs = \[\"10.0.1.0\/24\", \"10.0.2.0\/24\"\]/web_subnet_cidrs = [\"10.$((CLIENT_NUMBER * 10)).1.0\/24\", \"10.$((CLIENT_NUMBER * 10)).2.0\/24\"]/" terraform.tfvars
sed -i "s/app_subnet_cidrs = \[\"10.0.11.0\/24\", \"10.0.12.0\/24\"\]/app_subnet_cidrs = [\"10.$((CLIENT_NUMBER * 10)).11.0\/24\", \"10.$((CLIENT_NUMBER * 10)).12.0\/24\"]/" terraform.tfvars
sed -i "s/db_subnet_cidrs  = \[\"10.0.21.0\/24\", \"10.0.22.0\/24\"\]/db_subnet_cidrs  = [\"10.$((CLIENT_NUMBER * 10)).21.0\/24\", \"10.$((CLIENT_NUMBER * 10)).22.0\/24\"]/" terraform.tfvars

# Update non-production tfvars
cd ../nonprod
cp terraform.tfvars.example terraform.tfvars
sed -i "s/project_name         = \"myapp\"/project_name         = \"$CLIENT_NAME\"/" terraform.tfvars
sed -i "s/vpc_cidr             = \"10.1.0.0\/16\"/vpc_cidr             = \"$NONPROD_CIDR\"/" terraform.tfvars
sed -i "s/web_subnet_cidrs = \[\"10.1.1.0\/24\", \"10.1.2.0\/24\"\]/web_subnet_cidrs = [\"10.$((CLIENT_NUMBER * 10 + 1)).1.0\/24\", \"10.$((CLIENT_NUMBER * 10 + 1)).2.0\/24\"]/" terraform.tfvars
sed -i "s/app_subnet_cidrs = \[\"10.1.11.0\/24\", \"10.1.12.0\/24\"\]/app_subnet_cidrs = [\"10.$((CLIENT_NUMBER * 10 + 1)).11.0\/24\", \"10.$((CLIENT_NUMBER * 10 + 1)).12.0\/24\"]/" terraform.tfvars
sed -i "s/db_subnet_cidrs  = \[\"10.1.21.0\/24\", \"10.1.22.0\/24\"\]/db_subnet_cidrs  = [\"10.$((CLIENT_NUMBER * 10 + 1)).21.0\/24\", \"10.$((CLIENT_NUMBER * 10 + 1)).22.0\/24\"]/" terraform.tfvars

cd ../../..

echo ""
echo "✓ Client created successfully!"
echo ""
echo "Next steps:"
echo "1. Review and edit: $CLIENT_DIR/prod/terraform.tfvars"
echo "2. Review and edit: $CLIENT_DIR/nonprod/terraform.tfvars"
echo "3. Deploy: ./scripts/deploy-client.sh $CLIENT_NAME"
echo ""
