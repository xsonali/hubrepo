output "admin_password" {
  description = "The admin password (user-supplied or auto-generated)."
  value       = local.admin_password
  sensitive   = true
}

output "firewall_public_ip" {
  description = "The public IP address assigned to the Azure Firewall."
  value       = azurerm_public_ip.firewall_pip1.ip_address
}

output "vm_public_ip" {
  value = azurerm_public_ip.mgmt_pip.ip_address
}

output "vpn_gateway_ip" {
  value = azurerm_public_ip.hub_vpn_gw_pip1.ip_address
}

output "vm_admin_username" {
  value = var.admin_user
}

output "firewall_private_ip" {
  value = azurerm_firewall.hub_fw.ip_configuration[0].private_ip_address
}


