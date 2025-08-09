# ------------------------------------------------------------------
# Azure Firewall Instance
# ------------------------------------------------------------------
resource "azurerm_firewall" "hub_fw" {
  name                = "hub-fw"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.fw_policy.id

  ip_configuration {
    name                 = "fw-configuration"
    subnet_id            = azurerm_subnet.az_firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_pip1.id
  }

  tags = {
    environment = "hub-vnet"
    createdBy   = "terraform"
    owner       = "Gholam"
  }
}

# ------------------------------------------------------------------
# Public IP for Azure Firewall
# ------------------------------------------------------------------
resource "azurerm_public_ip" "firewall_pip1" {
  name                = "hub-fw-pip"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = {
    environment = "hub-vnet"
    createdBy   = "terraform"
    owner       = "Gholam"
  }
}

# ------------------------------------------------------------------
# Azure Firewall Policy
# ------------------------------------------------------------------
resource "azurerm_firewall_policy" "fw_policy" {
  name                = "hub-fw-policy"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
}

# ------------------------------------------------------------------
# NAT Rule Collection Group
# ------------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "rdp_nat_rule_group" {
  name               = "RDPNatRuleCollectionGroup"  # Unique name
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 100

  nat_rule_collection {
    name     = "rdp-nat"
    priority = 100
    action   = "Dnat"

    rule {
      name                = "rdp-desktop"
      source_addresses    = ["192.168.1.0/24"]
      destination_ports   = ["3389"]
      destination_address = azurerm_public_ip.firewall_pip1.ip_address
      translated_address  = "10.0.3.4"
      translated_port     = "3389"
      protocols           = ["TCP"]
    }
  }
}

# ------------------------------------------------------------------
# Network Rule Collection Group
# ------------------------------------------------------------------
resource "azurerm_firewall_policy_rule_collection_group" "rdp_network_rule_group" {
  name               = "RDPNetworkRuleCollectionGroup"  # Unique name
  firewall_policy_id = azurerm_firewall_policy.fw_policy.id
  priority           = 200

  network_rule_collection {
    name     = "AllowRDPInboundOutbound"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "Allow-RDP-Inbound"
      protocols             = ["TCP"]
      source_addresses      = ["192.168.1.0/24"]
      destination_addresses = [azurerm_public_ip.firewall_pip1.ip_address]
      destination_ports     = ["3389"]
    }

    rule {
      name                  = "Allow-RDP-Outbound"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.1.4"] # Firewall private IP
      destination_addresses = ["10.0.3.4"] # VM private IP
      destination_ports     = ["3389"]
    }
  }
}
