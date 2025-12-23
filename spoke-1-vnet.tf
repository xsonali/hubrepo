# Spoke1 resource group
resource "azurerm_resource_group" "spoke1_rg" {
  name     = local.spoke1_resource_group
  location = local.region
    
  tags = {
    environment = "Dev"
	owner       = "Admin"
	workload    = "spoke1-vnet"
  }
}

# Spoke1 vnet
resource "azurerm_virtual_network" "spoke1_vnet" {
  name                 = "${local.prefix_spoke1}-vnet"
  location             = local.region
  resource_group_name  = azurerm_resource_group.spoke1_rg.name
  address_space        = [local.spoke1_address_space]
}
  

#Spoke1 subnets
resource "azurerm_subnet" "spoke1_subnets" {
  for_each             = local.spoke1_subnets
  name                 = each.key
  resource_group_name  = azurerm_resource_group.spoke1_rg.name
  address_prefixes     = [each.value]
}

# Peering spoke1 to hub
resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                         = "spoke1-to-bub"
  resource_group_name          = azurerm_resource_group.spoke1_rg.name
  virtual_network_name         = azurerm_virtual_network.spoke1_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forward_traffic        = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
  
  depends_on = [
    azurerm_virtual_network.spoke1_vnet,
	azurerm_virtual_network.hub_vnet
  ]
}

# Network Interface
resource "azurerm_network_interface" "spoke1_workload_nic" {
  name                  = "${local.prefix_spoke1}-workload-nic"
  location              = azurerm_resource_group.spoke1_rg.location
  resource_group_name   = azurerm_resource_group.spoke1_rg.name
  
  ip_configuration {
    name                          = "ipconfig1"
	subnet_id                     = azurerm_subnet.spoke1_subnets["Workloadsubnet"].id
	private_ip_address_allocation = "Dynamic"
  }
  
  tags = {
    environment = "Dev"
	owner       = "Admin"
	workload    = "spoke1-vnet"
  }
}

# Virtual Machine in Workloadsubnet of Spoke1_vnet
resource "azurerm_linux_virtual_machine" "spoke1_workload_vm" {
  name                  = "${local.prefix_spoke1}-workload-vm"
  location              = azurerm_resource_group.spoke1_rg.location
  resource_group_name   = azurerm_resource_group.spoke1_rg.name
  size                  = var.vmsize
  network_interfce_ids  = [azurerm_network_interface.spoke1_workload_nic.id]
  admin_username        = var.admin_user
  
  admin_ssh_key {
    username      = var.admin_user
    public_key    = var.ssh_public_key
  }
   
  os_disk {
    name                    = "${local.prefix_spoke1}-osdisk"
	caching                 = "ReadWrite"
	storage_account_type    = "Standard_LRS"
  }
  
  source_image_reference {
    publisher = "Canonical"
	offer     = "0001-com-ubuntu-server-jammy"
	sku       = "22_04_lts-gen2"
	version   = "latest"
  }
  
  disable_password_authentication = true
  
  tags = {
    environment = "Dev"
	owner       = "Admin"
	workload    = "spoke1-vnet"
  }
}

  
