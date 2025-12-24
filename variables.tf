# =====================
# Hub Subnets
# =====================
variable "hub_subnets" {
  description = "Subnets for the Hub VNet"
  type = map(string)
  default = {
    AzureFirewallSubnet = "10.0.1.0/26"
    GatewaySubnet       = "10.0.2.0/27"
    hub_mgmt            = "10.0.3.0/27"
  }
}

# =====================
# Spoke1 Subnets
# =====================
variable "spoke1_subnets" {
  description = "Subnets for Spoke1 VNet"
  type = map(string)
  default = {
    workload = "10.1.1.0/24"
    mgmt     = "10.1.2.0/24"
  }
}

# =====================
# Spoke2 Subnets
# =====================
variable "spoke2_subnets" {
  description = "Subnets for Spoke2 VNet"
  type = map(string)
  default = {
    workload = "10.2.1.0/24"
    mgmt     = "10.2.2.0/24"
  }
}

# =====================
# Admin Credentials
# =====================
variable "admin_user" {
  description = "Username for VM"
  type        = string
  default     = "localadmin"
}

variable "admin_password" {
  description = "Password for admin user"
  type        = string
  sensitive   = true
  default     = null
}

# =====================
# VM Size
# =====================
variable "vmsize" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B2ms"
}

# =====================
# P2S Root Certificate
# =====================
variable "p2s_root_cert" {
  description = "The root certificate for Point-to-Site VPN"
  type        = string
  sensitive   = true
}

# =====================
# SSH Public Key
# =====================
variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

# =====================
# OS Type
# =====================
variable "os_type" {
  description = "Operating system type for VM"
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}

# =====================
# Hub Subnet Resources
# =====================
resource "azurerm_subnet" "hub_subnets" {
  for_each             = var.hub_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [each.value]
}
