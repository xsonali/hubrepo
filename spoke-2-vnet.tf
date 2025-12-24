# Resource group
resource "azurerm_resource_group" "spoke2_rg" {
  name     = local.spoke2_resource_group
  location = local.region

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "spoke2-vnet"
  }
}

# Spoke2 virtual network
resource "azurerm_virtual_network" "spoke2_vnet" {
  name                = "${local.prefix_spoke2}-vnet"
  location            = azurerm_resource_group.spoke2_rg.location
  resource_group_name = azurerm_resource_group.spoke2_rg.name
  address_space       = [local.spoke2_address_space]

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "spoke2-vnet"
  }
}

# Spoke2 subnets
resource "azurerm_subnet" "spoke2_subnets" {
  for_each             = local.spoke2_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.spoke2_rg.name
  virtual_network_name = azurerm_virtual_network.spoke2_vnet.name
  address_prefixes     = [each.value]
}

# Spoke2 to Hub virtual network peering
resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                      = "spoke-to-hub"
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


  