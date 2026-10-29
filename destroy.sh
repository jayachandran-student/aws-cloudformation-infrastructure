#!/bin/bash

# ─── CloudFormation Stack Deletion Script ────────────────────
# Usage: ./scripts/destroy.sh [template] [environment]
# Example: ./scripts/destroy.sh full-infrastructure dev

TEMPLATE=${1:-full-infrastructure}
ENVIRONMENT=${2:-dev}
REGION="ap-south-1"
STACK_NAME="${ENVIRONMENT}-${TEMPLATE}-stack"

echo "⚠️  WARNING: This will delete the CloudFormation stack!"
echo "   Stack Name : ${STACK_NAME}"
echo "   Region     : ${REGION}"
echo ""
read -p "Are you sure? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
  echo "❌ Deletion cancelled."
  exit 0
fi

echo ""
echo "🗑️  Deleting stack: ${STACK_NAME}..."
aws cloudformation delete-stack \
  --stack-name ${STACK_NAME} \
  --region ${REGION}

echo "⏳ Waiting for deletion to complete..."
aws cloudformation wait stack-delete-complete \
  --stack-name ${STACK_NAME} \
  --region ${REGION}

echo "✅ Stack deleted successfully!"
