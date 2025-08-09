# Azure Hub-Spoke Infrastructure with Terraform

This project builds a secure, scalable, enterprise-grade infrastructure on Microsoft Azure using Terraform. It employs a Hub-Spoke network topology and integrates firewall, P2S, virtual machines, monitoring, and role-based access control — all automated via Infrastructure as Code (IaC) and deployed using GitHub (Codespaces).
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
- **P2S VPN**, **Azure Firewall**
- **Virtual Machines (Linux/Windows)**
- **Azure Monitor**, **Log Analytics Workspace**
- **RBAC**, **Resource Groups**, **Tags**
---

## Architecture Overview

The design follows a Hub-Spoke topology with secure access via Point-to-Site (P2S) VPN and centralized monitoring through Azure Sentinel. Azure Sentinel is deployed in a separate resource group by importing the existing workspace to improve manageability and scalability.


-This diagram illustrates the hub-spoke network architecture deployed in Microsoft Azure. Please note the diagram may differ slightly from the actual deployment.

                            +---------------------+
                            |       Internet      |
                            +----------+----------+
                                       |
                                       |
                             +---------v---------+
                             |    P2S VPN Gateway |  <-- Secure remote access via Point-to-Site VPN
                             +---------+---------+
                                       |
                           +-----------v-----------+
                           |       Hub VNet        |
                           |  +-----------------+  |
                           |  | Azure Firewall  |  |  <-- Centralized security & firewall policies
                           |  +-----------------+  |
                           +-----------+-----------+
                                       |
                +----------------------+------------------------+
                |                      |                        |
       +--------v--------+    +--------v--------+       +-------v--------+
       |    Spoke VNet1  |    |    Spoke VNet2  |       |   Spoke VNet3  |
       |   (Web Tier)    |    |   (App Tier)    |       | (DB / Infra)   |
       | +-------------+|    | +-------------+|       | +-------------+|
       | | Virtual     ||    | | Virtual     ||       | | Virtual     ||
       | | Machines    ||    | | Machines    ||       | | Machines    ||
       | +-------------+|    | +-------------+|       | +-------------+|
       +----------------+    +----------------+       +----------------+
                |                      |                        |
       +--------v--------+    +--------v--------+       +-------v--------+
       | Network Security|    | Network Security|       | Network Security|
       | Groups (NSGs)   |    | Groups (NSGs)   |       | Groups (NSGs)   |
       +-----------------+    +-----------------+       +-----------------+

                           (All logs forwarded to)

                               +-----------------+
                               | Log Analytics   |
                               | Workspace       |  <-- Centralized log collection
                               +-----------------+
                                        |
                                        |
                               +-----------------+
                               | Azure Sentinel  |  <-- Security monitoring & alerting
                               +-----------------+




## Project Structure

azure-hub-spoke-project/ ├── main.tf ├── variables.tf ├── outputs.tf ├── provider.tf ├── terraform.tfvars ├── modules/ │ ├── networking/ │ ├── compute/ │ ├── security/ │ └── firewall/ └── README.md
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
•	Secure access architecture with P2S VPN
•	Visibility and control via monitoring and logging
•	Ready-to-showcase architecture for portfolio or interviews
________________________________________
License
This project is licensed under the MIT License. Feel free to fork and customize.
---
