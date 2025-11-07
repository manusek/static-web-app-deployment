# 🌐 Static Website Deployment with Terraform (AWS S3 + CloudFront)

This project provisions an **AWS S3 bucket** for static website hosting and a **CloudFront CDN distribution** for global content delivery using **Terraform**.

It includes remote state management via **S3 backend** and **DynamoDB** for state locking.

---
```
## 📁 Repository Structure
.
├── 01_main.tf                        # Root configuration — calls all modules
├── 02_variables.tf                   # Input variables (tags, bucket name, etc.)
├── 03_locals.tf                      # Local variables 
├── 04_terraform.tfvars               # Variable values (local or per-env)
│
├── website-content/
│   ├──  index.html                   # Static website home page
│   └──  error.html                   # Website for errors
|
├── modules/
│   ├── s3-website-bucket/
│   │   ├── 01_main.tf                # S3 bucket, policies, website configuration
│   │   ├── 02_variables.tf
|   |   ├── 03_locals.tf
|   |   ├── 04_versions.tf
│   │   └── 05_outputs.tf
│   │
│   ├── cloudfront-cdn/
│   │   ├── 01_main.tf                # CloudFront distribution
│   │   ├── 02_variables.tf
|   |   ├── 03_locals.tf
|   |   ├── 04_versions.tf
│   │   └── 05_outputs.tf
|   |
│   ├── waf-security/
│   │   ├── 01_main.tf                # WAF configuration
│   │   ├── 02_variables.tf
|   |   ├── 03_locals.tf
|   |   ├── 04_versions.tf
│   │   └── 05_outputs.tf
|   |
│   ├── s3-logging-bucket/
│   │   ├── 01_main.tf                # S3 bucket, policies, website configuration
│   │   ├── 02_variables.tf
|   |   ├── 03_locals.tf
|   |   ├── 04_versions.tf
│   │   └── 05_outputs.tf
|   |
│   └── lambda-edge-redirect/
│       ├── 01_main.tf                # Lambda@Edge function for HTTPS or path redirects
│       ├── 02_variables.tf
|       ├── 03_locals.tf
|       ├── 04_version.tf
│       └── 05_outputs.tf
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


