#!/bin/bash

# ─── CloudFormation Deployment Script ────────────────────────
# Usage: ./scripts/deploy.sh [template] [environment]
# Example: ./scripts/deploy.sh full-infrastructure dev

TEMPLATE=${1:-full-infrastructure}
ENVIRONMENT=${2:-dev}
REGION="ap-south-1"
STACK_NAME="${ENVIRONMENT}-${TEMPLATE}-stack"
TEMPLATE_FILE="templates/${TEMPLATE}.yaml"
PARAMETERS_FILE="parameters/${ENVIRONMENT}-parameters.json"

echo "🚀 Deploying CloudFormation Stack..."
echo "   Template   : ${TEMPLATE_FILE}"
echo "   Environment: ${ENVIRONMENT}"
echo "   Stack Name : ${STACK_NAME}"
echo "   Region     : ${REGION}"
echo ""

# Validate template first
echo "✅ Validating template..."
aws cloudformation validate-template \
  --template-body file://${TEMPLATE_FILE} \
  --region ${REGION}

if [ $? -ne 0 ]; then
  echo "❌ Template validation failed. Exiting."
  exit 1
fi

echo "✅ Template is valid!"
echo ""

# Deploy stack
echo "🔄 Deploying stack..."
aws cloudformation deploy \
  --template-file ${TEMPLATE_FILE} \
  --stack-name ${STACK_NAME} \
  --parameter-overrides file://${PARAMETERS_FILE} \
  --capabilities CAPABILITY_NAMED_IAM \
  --region ${REGION}

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Stack deployed successfully!"
  echo ""
  echo "📊 Stack Outputs:"
  aws cloudformation describe-stacks \
    --stack-name ${STACK_NAME} \
    --region ${REGION} \
    --query "Stacks[0].Outputs" \
    --output table
else
  echo "❌ Deployment failed!"
  exit 1
fi
