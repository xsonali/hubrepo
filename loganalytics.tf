# Diagnostic Settings for Azure Firewall
resource "azurerm_monitor_diagnostic_setting" "fw_logs" {
  name               = "fw-diagnostics"
  target_resource_id = azurerm_firewall.hub_fw.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.hub_logs.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
    retention_policy {
      enabled = false
      days    = 0
    }
  }
}

# Log Analytics Workspace with Retention
resource "azurerm_log_analytics_workspace" "hub_logs" {
  name                = "hub-fw-logs"
  location            = azurerm_resource_group.hub_vnet_rg.location
  resource_group_name = azurerm_resource_group.hub_vnet_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    environment = "hub-vnet"
    createdBy   = "terraform"
    owner       = "Gholam"
  }
}

# Metric Alert for RDP Traffic
resource "azurerm_monitor_metric_alert" "rdp_alert" {
  name                = "rdp-traffic-alert"
  resource_group_name = azurerm_resource_group.hub_rg.name
  scopes              = [azurerm_virtual_network_gateway.vpn_gw.id]
  description         = "Alert on VPN ingress traffic"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.Network/virtualNetworkGateways"
    metric_name      = "TunnelIngressBytes"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50000
  }

  action {
    action_group_id = azurerm_monitor_action_group.alert_group.id
  }
}

# Microsoft Sentinel Onboarding
resource "azurerm_sentinel_log_analytics_workspace_onboarding" "hub_logs" {
  workspace_id = azurerm_log_analytics_workspace.hub_logs.id
}

# Sentinel configuration
resource "azurerm_sentinel_alert_rule_scheduled" "rdp_spike" {
  name                       = "High RDP Traffic Detected"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.hub_logs.id
  display_name               = "High RDP Traffic Detected"
  severity                   = "Medium"
  query_frequency            = "PT5M"
  query_period               = "PT5M"
  trigger_operator           = "GreaterThan"
  trigger_threshold          = 0
  enabled                    = true
  description                = "Detects unusually high RDP traffic through Azure Firewall"
  depends_on                 = [azurerm_sentinel_log_analytics_workspace_onboarding.hub_logs]

  query = <<KQL
AzureDiagnostics
| where Category == "AzureFirewallNetworkRule"
| where Action == "Allow"
| where Protocol == "TCP" and DestinationPort == "3389"
| summarize count() by bin(TimeGenerated, 5m), SourceIP
| where count_ > 100
  KQL

  tactics             = ["Discovery"]
  techniques          = ["T1046"]
  suppression_enabled = false

  event_grouping {
    aggregation_method = "AlertPerResult"
  }

  incident {
    create_incident_enabled = true

    grouping {
      enabled                  = true
      reopen_closed_incidents = true
      lookback_duration        = "PT1H"
      entity_matching_method   = "AllEntities"
    }
  }

  entity_mapping {
    entity_type = "IP"

    field_mapping {
      column_name = "SourceIP"
      identifier  = "Address"
    }
  }

  custom_details = {
    environment = "hub_vnet"
    createdBy   = "terraform"
    owner       = "Gholam"
  }
}
