# 🌐 Static Website Deployment with Terraform (AWS S3 + CloudFront)

This project provisions an **AWS S3 bucket** for static website hosting and a **CloudFront CDN distribution** for global content delivery using **Terraform**.

It includes remote state management via **S3 backend** and **DynamoDB** for state locking.

---
```
## 📁 Repository Structure
.
├── main.tf                        # Root configuration — calls all modules
├── variables.tf                   # Input variables (tags, bucket name, etc.)
├── terraform.tfvars               # Variable values (local or per-env)
│
├── website-content/
│   └── index.html                 # Static website home page
│
├── modules/
│   ├── s3-website-bucket/
│   │   ├── main.tf                # S3 bucket, policies, website configuration
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── cloudfront-cdn/
│   │   ├── main.tf                # CloudFront distribution configuration
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── waf-security/
│   │   ├── main.tf                # AWS WAF (Web ACL) setup and associations
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── lambda-edge-redirect/
│       ├── main.tf                # Lambda@Edge function for HTTPS or path redirects
│       ├── variables.tf
│       └── outputs.tf
│
└── backend/
└── terraform.tfstate          # Remote state file (stored in S3)
```
---

## 🚀 Deployment Steps

1️⃣ Initialize the project: 

  terraform init


2️⃣ Validate configuration:

  terraform validate


3️⃣ Preview the deployment plan

  terraform plan


4️⃣ Deploy the infrastructure

  terraform apply

8️⃣ Destroy the infrastructure (cleanup)

  terraform destroy


