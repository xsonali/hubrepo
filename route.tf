# ------------------------------------------------------------------
# Unified Route Table for HubMgmtSubnet
# ------------------------------------------------------------------
resource "azurerm_route_table" "hub_mgmt_rt" {
  name                = "hub-mgmt-route-table"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  route {
    name                   = "rdp-to-fw"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
  }

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "hub-route"
  }
}

# ------------------------------------------------------------------
# Associate Route Table to HubMgmtSubnet
# ------------------------------------------------------------------
resource "azurerm_subnet_route_table_association" "hub_mgmt_rt_assoc" {
  subnet_id      = azurerm_subnet.hub_subnets["hub_mgmt"].id
  route_table_id = azurerm_route_table.hub_mgmt_rt.id
}

# Route to Gateway to mgmt subnet
resource "azurerm_route_table" "gateway_rt" {
  name                = "gateway-subnet-rt"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  route {
    name                   = "to-hub-mgmt-via-firewall"
    address_prefix         = "10.0.3.0/24" # HubMgmtSubnet
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
  }

  tags = {
    environment = "hub-vnet"
    createdBy   = "terraform"
    owner       = "Gholam"
  }
}
# Associate Route Table to Gateway subnet
resource "azurerm_subnet_route_table_association" "gateway_rt_assoc" {
  subnet_id      = azurerm_subnet.hub_subnets["GatewaySubnet"].id
  route_table_id = azurerm_route_table.gateway_rt.id
}
