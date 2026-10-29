# ☁️ AWS CloudFormation Infrastructure Deployment

Automated AWS infrastructure deployment using CloudFormation (Infrastructure as Code). Provisions EC2 instances, Security Groups, and S3 buckets using reusable YAML templates with environment-based parameters.

---

## 🏗️ Architecture

```
CloudFormation Template (YAML)
            ↓
AWS CloudFormation Stack
            ↓
    ┌───────┬───────┐
    ↓       ↓       ↓
  EC2   Security   S3
Instance  Group   Bucket
    ↓       ↓       ↓
  Apache  Ports  Versioning
  Server  22,80  Encryption
         443
```

---

## 🛠️ Tech Stack

| Service | Purpose |
|---------|---------|
| AWS CloudFormation | Infrastructure as Code (IaC) |
| AWS EC2 | Virtual server (t2.micro) |
| AWS Security Groups | Firewall and access control |
| AWS S3 | Secure object storage |
| AWS IAM | Permissions management |
| AWS CLI | Deployment from terminal |

---

## ✨ Features

- ✅ Three modular CloudFormation templates
- ✅ Environment-based parameters (dev/staging/production)
- ✅ EC2 with Apache auto-installed via UserData
- ✅ Security Group with SSH, HTTP, HTTPS rules
- ✅ S3 with encryption, versioning, and public access blocked
- ✅ Deployment and teardown shell scripts
- ✅ Stack outputs for easy resource lookup
- ✅ Template validation before deployment

---

## 📁 Project Structure

```
aws-cloudformation-infrastructure/
├── templates/
│   ├── ec2-setup.yaml            # EC2 + Security Group only
│   ├── s3-setup.yaml             # S3 bucket only
│   └── full-infrastructure.yaml  # EC2 + Security Group + S3
├── parameters/
│   ├── dev-parameters.json       # Dev environment values
│   └── production-parameters.json # Production environment values
├── scripts/
│   ├── deploy.sh                 # Deploy stack script
│   └── destroy.sh                # Delete stack script
└── README.md
```

---

## 🚀 Deployment Guide

### Prerequisites
- AWS Account with appropriate permissions
- AWS CLI installed and configured
- Bash terminal

### Step 1 — Clone the repository
```bash
git clone https://github.com/jayachandran-student/aws-cloudformation-infrastructure.git
cd aws-cloudformation-infrastructure
```

### Step 2 — Configure AWS CLI
```bash
aws configure
# Enter: AWS Access Key, Secret Key, Region (ap-south-1), Output format (json)
```

### Step 3 — Make scripts executable
```bash
chmod +x scripts/deploy.sh
chmod +x scripts/destroy.sh
```

### Step 4 — Deploy individual templates

**EC2 + Security Group only:**
```bash
aws cloudformation deploy \
  --template-file templates/ec2-setup.yaml \
  --stack-name dev-ec2-stack \
  --parameter-overrides file://parameters/dev-parameters.json \
  --capabilities CAPABILITY_NAMED_IAM \
  --region ap-south-1
```

**S3 Bucket only:**
```bash
aws cloudformation deploy \
  --template-file templates/s3-setup.yaml \
  --stack-name dev-s3-stack \
  --parameter-overrides file://parameters/dev-parameters.json \
  --region ap-south-1
```

**Full infrastructure (EC2 + Security Group + S3):**
```bash
./scripts/deploy.sh full-infrastructure dev
```

### Step 5 — View stack outputs
```bash
aws cloudformation describe-stacks \
  --stack-name dev-full-infrastructure-stack \
  --query "Stacks[0].Outputs" \
  --output table
```

### Step 6 — Delete stack (cleanup)
```bash
./scripts/destroy.sh full-infrastructure dev
```

---

## 📊 Templates Overview

### 1. ec2-setup.yaml
| Resource | Details |
|----------|---------|
| EC2 Instance | t2.micro, Amazon Linux 2 |
| Security Group | Ports 22, 80, 443 open |
| UserData | Apache auto-installed on boot |

### 2. s3-setup.yaml
| Feature | Details |
|---------|---------|
| Encryption | AES-256 server-side |
| Versioning | Configurable via parameter |
| Public Access | Fully blocked |
| HTTPS Only | Enforced via bucket policy |

### 3. full-infrastructure.yaml
Combines all resources above into a single deployable stack with environment-aware configuration.

---

## ⚙️ Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| EnvironmentType | dev | dev / staging / production |
| InstanceType | t2.micro | EC2 instance size |
| KeyPairName | my-key-pair | SSH key for EC2 access |
| BucketName | my-cloudformation-bucket | S3 bucket name prefix |
| EnableVersioning | true | Enable S3 versioning |

---

## 🔐 Security Features

- Security Group uses **least-privilege** port rules
- S3 bucket blocks **all public access**
- S3 enforces **HTTPS only** connections
- IAM follows **least-privilege principle**
- No hardcoded credentials anywhere

---

## 🧑‍💻 Author

**Jayachandran K**
- GitHub: [@jayachandran-student](https://github.com/jayachandran-student)
- LinkedIn: [jayachandran-k-6312ab376](https://www.linkedin.com/in/jayachandran-k-6312ab376)
- Email: jayachandran.k30@gmail.com

---

## 📜 License

This project is open source and available under the [MIT License](LICENSE).
