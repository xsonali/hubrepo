resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

locals {
  region   = "australiaeast"
  password = try(random_password.password[0].result, var.admin_password)

  # Hub
  prefix_hub         = "hub"
  hub_resource_group = "hub-vnet-rg-${random_string.suffix.result}"

  # Spoke 1
  prefix_spoke1         = "spoke1"
  spoke1_resource_group = "spoke1-vnet-rg-${random_string.suffix.result}"
  spoke1_address_space  = "10.1.0.0/16"
  spoke1_subnets = {
    workload = "10.1.1.0/24"
    mgmt     = "10.1.2.0/24"
  }

  # Spoke 2
  prefix_spoke2         = "spoke2"
  spoke2_resource_group = "spoke2-vnet-rg-${random_string.suffix.result}"
  spoke2_address_space  = "10.2.0.0/16"
  spoke2_subnets = {
    workload = "10.2.1.0/24"
    mgmt     = "10.2.2.0/24"
  }
}
