terraform {
  required_version = ">=1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = "09624d5e-dd06-4d7b-9cd9-462e3f5416d0"
}

resource "random_password" "password" {
  count  = var.admin_password == null ? 1 : 0
  length = 20
}
    