#!/bin/bash

# Destroy client infrastructure (both prod and nonprod)
# Usage: ./scripts/destroy-client.sh client-name

set -e

CLIENT_NAME=$1

if [ -z "$CLIENT_NAME" ]; then
    echo "Error: Client name required"
    echo "Usage: ./scripts/destroy-client.sh client-name"
    exit 1
fi

CLIENT_DIR="clients/$CLIENT_NAME"

if [ ! -d "$CLIENT_DIR" ]; then
    echo "Error: Client directory not found: $CLIENT_DIR"
    exit 1
fi

echo "=========================================="
echo "WARNING: Destroying infrastructure for: $CLIENT_NAME"
echo "=========================================="
echo ""
echo "This will destroy:"
echo "- Production VPC and all resources"
echo "- Non-Production VPC and all resources"
echo ""
read -p "Type client name to confirm: " confirm

if [ "$confirm" != "$CLIENT_NAME" ]; then
    echo "✗ Confirmation failed. Aborting."
    exit 1
fi

# Destroy Production first
echo ""
echo "Step 1: Destroying Production Environment"
echo "-----------------------------------------"
cd "$CLIENT_DIR/prod"

terraform destroy

echo "✓ Production environment destroyed"

# Destroy Non-Production
echo ""
echo "Step 2: Destroying Non-Production Environment"
echo "---------------------------------------------"
cd "../nonprod"

terraform destroy

echo "✓ Non-production environment destroyed"

echo ""
echo "=========================================="
echo "Destruction Complete for: $CLIENT_NAME"
echo "=========================================="
