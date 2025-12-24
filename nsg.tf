# NSG for HubMgmtSubnet
resource "azurerm_network_security_group" "mgmt_nsg" {
  name                = "hub-mgmt-nsg"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  security_rule {
    name                       = "Allow-RDP-From-Firewall"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
    source_port_range          = "*"
    destination_port_range     = "3389"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "hub-vnet"
  }
}



# Attach NSGs to Subnets
resource "azurerm_subnet_network_security_group_association" "mgmt_nsg_assoc" {
  subnet_id                 = azurerm_subnet.hub_subnets["hub_mgmt"].id
  network_security_group_id = azurerm_network_security_group.mgmt_nsg.id
}


