# Azure Hub-Spoke Infrastructure with Terraform

This project builds a **secure, scalable enterprise-grade infrastructure** on Microsoft Azure using Terraform. It uses a **Hub-Spoke network topology**, integrates **virtual machines**, **monitoring**, and **role-based access control**, all automated via Infrastructure as Code (IaC).
---
## Objectives
- Deploy a hub-spoke virtual network architecture with isolated workloads

- Provision secure virtual machines with P2S VPN access and Network Security Groups (NSGs)

- Implement diagnostics, activity logging, and firewall monitoring

- Manage resources using Role-Based Access Control (RBAC) and enforce governance policies

- Automate deployments using modular Terraform configurations

- Centralize private DNS zone management

- Apply security best practices by implementing Azure Firewall and Sentinel
---
## Architecture Overview

[ Internet ] | [ P2S VPN ] |  
Hub | Spoke1 | Spoke2 | VMs | Monitoring
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

The design follows a Hub-Spoke topology with secure access through P2S VPN and centralized monitoring hosted in the third spoke. Workloads are distributed across the spoke networks to enable scalability for web, application, and database/infrastructure tiers.

This diagram illustrates the hub network architecture deployed in Microsoft Azure. The spokes and the Sentinel components are not shown here to keep the file size compact. <img width="425" height="422" alt="hub-vnet-rg-m617-2" src="https://github.com/user-attachments/assets/562ee602-d807-46b1-bd7c-0c7f0ac051bb" />





## Project Structure

azure-hub-spoke-project/ Backend.tf | firewall.tf | locals.tf | main.tf | privateDNSzone.tf | route.tf | nsg.tf | variables.tf | outputs.tf | README.md
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
