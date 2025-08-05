# Spoke2 Resource Group
resource "azurerm_resource_group" "spoke2_rg" {
  name     = local.spoke2_resource_group
  location = local.region
}

# Spoke2 Virtual Network
resource "azurerm_virtual_network" "spoke2_vnet" {
  name                = "${local.prefix_spoke2}-vnet"
  address_space       = [local.spoke2_address_space]
  location            = local.region
  resource_group_name = azurerm_resource_group.spoke2_rg.name
}

# Spoke2 Workload Subnet
resource "azurerm_subnet" "spoke2_workload" {
  name                 = "workload-subnet"
  address_prefixes     = [local.spoke2_subnets.workload]
  resource_group_name  = azurerm_resource_group.spoke2_rg.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
}

# Spoke2 Management Subnet
resource "azurerm_subnet" "spoke2_mgmt" {
  name                 = "mgmt-subnet"
  address_prefixes     = [local.spoke2_subnets.mgmt]
  resource_group_name  = azurerm_resource_group.spoke2_rg.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
}

# Spoke2 to Hub Virtual Network Peering
resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                      = "spoke2-to-hub"
  resource_group_name       = azurerm_resource_group.spoke2_rg.name
  virtual_network_name      = azurerm_virtual_network.spoke2_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [
    azurerm_virtual_network.spoke2_vnet,
    azurerm_virtual_network.hub_vnet
  ]
}
