# Spoke1
resource "azurerm_resource_group" "spoke1_rg" {
  name     = local.spoke1_resource_group
  location = local.region
}

resource "azurerm_virtual_network" "spoke1_vnet" {
  name                = "${local.prefix_spoke1}-vnet"
  address_space       = [local.spoke1_address_space]
  location            = local.region
  resource_group_name = azurerm_resource_group.spoke1_rg.name
}

resource "azurerm_subnet" "spoke1_workload" {
  name                 = "workload-subnet"
  address_prefixes     = [local.spoke1_subnets.workload]
  resource_group_name  = azurerm_resource_group.spoke1_rg.name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
}

resource "azurerm_subnet" "spoke1_mgmt" {
  name                 = "mgmt-subnet"
  address_prefixes     = [local.spoke1_subnets.mgmt]
  resource_group_name  = azurerm_resource_group.spoke1_rg.name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
}

# Peering spoke1 to hub
resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = azurerm_resource_group.spoke1_rg.name
  virtual_network_name         = azurerm_virtual_network.spoke1_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [
    azurerm_virtual_network.spoke1_vnet,
    azurerm_virtual_network.hub_vnet
  ]
}
# Network Interface
resource "azurerm_network_interface" "spoke1_nic" {
  name                = "${local.prefix_spoke1}-nic"
  location            = azurerm_resource_group.spoke1_rg.location
  resource_group_name = azurerm_resource_group.spoke1_rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.spoke1_workload.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = local.prefix_spoke1
    owner       = "Gholam"
  }
}

# Virtual Machine in Spoke1
resource "azurerm_virtual_machine" "spoke1_vm" {
  name                  = "${local.prefix_spoke1}-vm"
  location              = azurerm_resource_group.spoke1_rg.location
  resource_group_name   = azurerm_resource_group.spoke1_rg.name
  network_interface_ids = [azurerm_network_interface.spoke1_nic.id]
  vm_size               = var.vmsize

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${local.prefix_spoke1}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${local.prefix_spoke1}-vm"
    admin_username = var.admin_user
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_user}/.ssh/authorized_keys"
      key_data = var.ssh_public_key
    }
  }

  tags = {
    environment = local.prefix_spoke1
    owner       = "Gholam"
  }

  depends_on = [azurerm_network_interface.spoke1_nic]
}


