# backend.tf
terraform {
  backend "azurerm" {
  resource_group_name = "backend-rg"
  storage_account_name = "backendstorge747x"
  container_name       = "ptstate"
  key                  = "tfstate"
  }
}