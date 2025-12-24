# Hub resource group
resource "azurerm_resource_group" "hub_rg" {
  name     = local.hub_resource_group
  location = local.region

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "hub-vnet"
  }
}

# Hub virtual network
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${local.prefix_hub}-vnet"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = [local.hub_address_space]

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "hub-vnet"
  }
}

# Create subnets
resource "azurerm_subnet" "hub_subnets" {
  for_each             = local.hub_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = [each.value]
}

# Create Network Interface
resource "azurerm_network_interface" "mgmt_nic" {
  name                = "${local.prefix_hub}-mgmt-nic"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  ip_configuration {
    name                          = "${local.prefix_hub}-mgmt"
    subnet_id                     = azurerm_subnet.hub_subnets["HubMgmtSubnet"].id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.3.4"
  }

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "hub-vnet"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "mgmt_vm" {
  name                 = "${local.prefix_hub}-mgmt-vm"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  location             = azurerm_resource_group.hub_rg.location
  network_iterface_ids = [azurerm_network_interface.mgmt_nic.id]
  vm_size              = var.vmsize

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacener"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix_hub}-mgmt-vm-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "{local.prefix_hub}-mgmt-op-vm"
    admin_username = var.admin_user
    admin_password = var.admin_password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "hub-vnet"
  }

  depends_on = [
    azurerm_network_interface.mgmt_nic
  ]
}

# Public IP
resource "azurerm_public_ip" "hub_vnet_gw_pip1" {
  name                = "Hub-GW-PIP1"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  allocation_method = "Static"
  sku               = "Standard"
}

# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "hub_vnet_gw" {
  name                = "Hub-VPN-GW1"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "vnetGWConfig"
    public_ip_address_id          = azurerm_public_ip.hub_vnet_gw_pip1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_subnets["GatewaySubnet"].id
  }

  vpn_client_configuration {
    address_space = ["192.168.1.0/24"]

    root_certificate {
      name             = "P2SRoot"
      public_cert_data = var.p2s_root_cert
    }
  }

  depends_on = [
    azurerm_public_ip.hub_vnet_gw_pip1
  ]
}







