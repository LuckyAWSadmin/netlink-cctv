# Copilot Instructions for Netlink CCTV

## Project Overview
- **Netlink CCTV** provisions a simple web application on AWS using Terraform and automates deployment with GitHub Actions.
- The infrastructure consists of a VPC, public subnet, security group, EC2 instance (Ubuntu 22.04), and Nginx web server.
- The web application is static (HTML/CSS/JS) and is deployed to the EC2 instance via Terraform user data.

## Key Components
- `terraform/`: Infrastructure as Code (AWS VPC, EC2, security, outputs, variables)
  - `main.tf`: Main resources (VPC, subnet, security group, EC2, etc.)
  - `user_data.sh`: Bootstraps EC2 with Nginx and deploys the webapp
  - `outputs.tf`, `variables.tf`, `terraform.tfvars`: Configuration and outputs
- `webapp/`: Static site assets (HTML, CSS, JS)
- `.github/workflows/`: CI/CD automation
  - `terraform.yml`: Lints, plans, and applies Terraform on push to `main`
  - `deploy.yml`: Deploys webapp changes to EC2 using Terraform outputs and SSH

## Developer Workflows
- **Infrastructure**: Edit Terraform files in `terraform/`, then commit/push to `main` to trigger CI/CD.
- **Webapp**: Edit files in `webapp/`, then commit/push to `main` to trigger redeployment.
- **Secrets**: AWS and SSH credentials are managed via GitHub Actions secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`, `SSH_PUBLIC_KEY`, `SSH_PRIVATE_KEY`).
- **Outputs**: Public IP/DNS of the EC2 instance are available via Terraform outputs.

## Patterns & Conventions
- All infrastructure is managed via Terraform; do not manually modify AWS resources.
- The EC2 instance is always provisioned with the latest Ubuntu 22.04 AMI.
- Nginx is installed and started via `user_data.sh`.
- The webapp is static and does not require a backend.
- SSH access is controlled by the `allowed_ssh_cidr` variable (default: open to all, but should be restricted).
- All changes are applied via GitHub Actions; do not run Terraform manually unless debugging.

## Examples
- To add a new webapp asset, place it in `webapp/` and reference it in `index.html`.
- To change the EC2 instance type, update `variables.tf` and/or `terraform.tfvars`.
- To restrict SSH, set `allowed_ssh_cidr` in `terraform.tfvars` or via GitHub secrets.

## References
- See `terraform/main.tf` for infrastructure structure.
- See `.github/workflows/terraform.yml` and `deploy.yml` for automation logic.
- See `webapp/index.html` for the entry point of the static site.

---
For questions about project-specific workflows or patterns, review the referenced files or ask for clarification.
