# Azure Hub-Spoke Infrastructure with Terraform

This project builds a **secure, scalable enterprise-grade infrastructure** on Microsoft Azure using Terraform. It uses a **Hub-Spoke network topology**, integrates **virtual machines**, **monitoring**, and **role-based access control**, all automated via Infrastructure as Code (IaC).
---
## Objectives

- Deploy hub-spoke VNet architecture with isolated workloads
- Provision secure virtual machines using Bastion and NSGs
- Implement diagnostics, activity logging, and VM monitoring
- Manage resources with RBAC and enforce governance
- Automate everything using modular Terraform
---
## Architecture Overview

[ Internet ] | [ Azure Bastion ] | [ Hub VNet ] / | 
Spoke1 Spoke2 Spoke3 (Web) (App) (DB/Infra) | | | VMs VMs VMs + Monitoring
---
## Technologies Used

- **Terraform (IaC)** for automated deployment
- **Azure Virtual Networks & Subnets**
- **Network Security Groups (NSGs), Route Tables**
- **Azure Bastion**, **Azure Firewall**
- **Virtual Machines (Linux/Windows)**
- **Azure Monitor**, **Log Analytics Workspace**
- **RBAC**, **Resource Groups**, **Tags**
---

## Architecture Overview

The design follows a Hub-Spoke topology with secure access via P2S VPN and central monitoring in the third spoke. Workloads are distributed across spoke networks for web, application, and database/infra tiers.


_This diagram illustrates the hub network architecture deployed in Microsoft Azure. <img width="425" height="422" alt="hub-vnet-rg-m617-2" src="https://github.com/user-attachments/assets/562ee602-d807-46b1-bd7c-0c7f0ac051bb" />





## Project Structure

azure-hub-spoke-project/ ├── main.tf ├── variables.tf ├── outputs.tf ├── provider.tf ├── terraform.tfvars ├── modules/ │ ├── networking/ │ ├── compute/ │ ├── security/ │ └── monitoring/ └── README.md
---
## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/azure-hub-spoke-project.git
   cd azure-hub-spoke-project
2.	Update terraform.tfvars with your values:
o	Location
o	Resource Group name
o	VM credentials
o	Subnet CIDRs
3.	Initialize and apply:
4.	terraform init
5.	terraform plan
6.	terraform apply
________________________________________
Monitoring & Logging
•	VM Insights enabled via azurerm_monitor_diagnostic_setting
•	Activity Logs collected centrally in Log Analytics Workspace
•	Storage Account used for boot diagnostics
________________________________________
Key Learnings & Outcomes
•	Real-world Azure design following best practices
•	Full-stack IaC deployment using reusable modules
•	Secure access architecture with Bastion and no public IPs
•	Visibility and control via monitoring and logging
•	Ready-to-showcase architecture for portfolio or interviews
________________________________________
License
This project is licensed under the MIT License. Feel free to fork and customize.
---
