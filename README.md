# SecureOps-Project

## Overview
The **SecureOps-Project** is focused on enhancing the security and operational efficiency of cloud infrastructure and DevOps processes. This project utilizes **Terraform VCS (Version Control System) integration** for automating infrastructure as code (IaC) deployments and follows best practices for security, monitoring, and continuous deployment.

## Objectives
- Ensure robust cloud infrastructure security.
- Automate DevOps workflows using Terraform VCS.

## Features
- **Terraform CI/CD Pipelines**: Automate the deployment of infrastructure using Terraform's VCS integration.
- **Cloud Security**: Harden the cloud infrastructure by applying security best practices.

## Technologies Used
- **Cloud Providers**: AWS
- **CI/CD Tools**: Terraform Cloud/Enterprise (VCS-Integrated)
- **Infrastructure as Code**: Terraform
- **Security Tools**: Vault, AWS IAM

---

## CI/CD with Terraform VCS

This project leverages **Terraform Cloud's VCS-driven workflows** for automated infrastructure deployment. Here’s an overview of the process:

### Setup Overview:
1. **Terraform VCS Integration**: Connects your GitHub or GitLab repository to Terraform Cloud.
   - The repository contains your Terraform configuration files (`.tf` files).
2. **Automatic Plan and Apply**:
   - Whenever changes are pushed to the repository, Terraform triggers a plan to evaluate the changes.
   - After review, approved changes are automatically applied to the infrastructure.
3. **Workspaces**: Terraform Workspaces are used to manage environments (e.g., staging, production).
4. **Variables and Secrets**: Terraform Cloud securely manages environment variables and sensitive information.

### CI/CD Workflow:
- **Push Changes to VCS**: Any change pushed to the repository triggers a Terraform plan.
- **Automated Plan**: Terraform evaluates the proposed changes and generates an execution plan.
- **Manual or Automated Apply**: After review (manual approval or auto-approval based on policies), the plan is applied.

---

## Daily Progress

### Day 1: Project Initialization
- **Task**: Setup GitHub repository and Terraform VCS integration.
- **Actions**: 
  - Initialized GitHub repository and created basic Terraform configuration files.
  - Integrated GitHub repository with Terraform Cloud for automatic plan and apply.
  - Defined Terraform workspace structure (staging and production).
- **Outcome**: GitHub repository and Terraform Cloud are connected, with basic CI/CD workflow in place.
![Day 1](figures/day1.png)
---

### Day 2: Configure JWT Auth Method in Vault
- **Task**: Configure JWT authentication method in Vault for secure access management.
- **Actions**:
  - Integrated Vault secret engine with the JWT auth method.
- **Outcome**: Vault secret engine and JWT auth method are configured for secure access.
![Day 1](figures/day2.png)
---

### Day 3 & 4: Cloud Infrastructure Setup with Terraform
- **Task**: Complete the cloud infrastructure setup and improve the CI/CD pipeline by managing sensitive variables and configurations.
- **Actions**:
  - Configured environment variables and secrets (e.g., AWS access keys) in Terraform Cloud.
  - Configured VPC, subnets, and routing for the cloud infrastructure.
- **Outcome**: Cloud infrastructure setup is complete, managed through Terraform VCS workflow.

---

