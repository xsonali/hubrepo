# Hub-vnet
resource "azurerm_resource_group" "hub_vnet_rg" {
  name     = local.hub_resource_group
  location = local.region
}

resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${local.prefix_hub}-vnet"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "hub-vnet"
    createdBy   = "terraform"
    owner       = "Gholam"

  }
}

resource "azurerm_subnet" "az_firewall_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.1.0/26"]
}

resource "azurerm_subnet" "hub_gateway_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.2.0/27"]
}

resource "azurerm_subnet" "hub_mgmt" {
  name                 = "MgmtSubnet"
  resource_group_name  = azurerm_resource_group.hub_vnet_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["10.0.3.0/27"]
}

resource "azurerm_network_interface" "mgmt_nic" {
  name                = "${local.prefix_hub}-nic"
  location            = local.region
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  # ip_forwarding_enabled = true

  ip_configuration {
    name                          = local.prefix_hub
    subnet_id                     = azurerm_subnet.hub_mgmt.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.3.4"
  }

  tags = {
    environment = local.prefix_hub
  }
}

# Virtual Machine
resource "azurerm_virtual_machine" "mgmt_vm" {
  name                  = "${local.prefix_hub}-vm"
  resource_group_name   = azurerm_resource_group.hub_vnet_rg.name
  location              = azurerm_resource_group.hub_vnet_rg.location
  network_interface_ids = [azurerm_network_interface.mgmt_nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix_hub}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix_hub}-vm"
    admin_username = var.admin_user
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  tags = {
    environment = local.prefix_hub
  }
}

# Virtual Network Gateway

resource "azurerm_public_ip" "hub_vpn_gw-pip1" {
  name                = "HubVPN-GW-PIP1"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name

  allocation_method = "Static"
  sku               = "Standard"
  zones             = ["1"]
}

resource "azurerm_virtual_network_gateway" "hub_vnet_gw" {
  name                = "Hub-VPN-GW1"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGWConfig"
    public_ip_address_id          = azurerm_public_ip.hub_vpn_gw-pip1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_gateway_subnet.id
  }

  vpn_client_configuration {
    address_space = ["192.168.1.0/24"]

    root_certificate {
      name             = "P2SRoot"
      public_cert_data = var.p2s_root_cert
    }
  }

  depends_on = [azurerm_public_ip.hub_vpn_gw-pip1]
}


 