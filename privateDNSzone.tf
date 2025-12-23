# Private DNS Zone - Blob Storage
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name

  tags = {
    environment = "Dev"
    owner       = "Admin"
    workload    = "PrivateDNSZone"
  }
}

# Private DNS Zone - Internal Corp
resource "azurerm_private_dns_zone" "custom_dns_link" {
  name                = "internal.corp"
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
}

