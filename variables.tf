variable "hub_subnets" {
  default = {
    AzureFirewallSubnet = "10.0.1.0/26"
    GatewaySubnet       = "10.0.2.0/27"
    hub_mgmt            = "10.0.3.0/27"
}

variable "spoke1_subnets" {
  workload = "10.1.1.0/24"
  mgmt     = "10.1.2.0/24"
}

variable "spoke2_subnets" {
  workload = "10.2.1.0/24"
  mgmt     = "10.2.2.0/24"
}

resource "azurerm_subnet" "hub_subnets" {
  for_each             = var.hub_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [each.value]
}


variable "admin_user" {
  description = "Username for VM"
  default     = "localadmin"
}

variable "admin_password" {
  description = "Password for admin user"
  type        = string
  default     = null
  sensitive   = true
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2ms"
}

variable "p2s_root_cert" {
  description = "The root certificate for Point-to-Site VPN"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

variable "os_type" {
  description = "Operating system type for VM"
  type        = string
  default     = "linux"
  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}