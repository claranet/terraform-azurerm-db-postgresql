#resource "azurerm_monitor_diagnostic_setting" "log_settings_storage" {
#  count = var.enable_logs_to_storage ? 1 : 0
#
#  name               = "logs-storage"
#  target_resource_id = azurerm_mysql_server.mysql_server.id
#
#  storage_account_id = var.logs_storage_account_id
#
#  log {
#    category = "MySqlSlowLogs"
#
#    retention_policy {
#      enabled = false
#    }
#  }
#
#  log {
#    category = "MySqlAuditLogs"
#
#    retention_policy {
#      enabled = false
#    }
#  }
#
#  metric {
#    category = "AllMetrics"
#    enabled  = false
#
#    retention_policy {
#      enabled = false
#    }
#  }
#}
#
#resource "azurerm_monitor_diagnostic_setting" "log_settings_log_analytics" {
#  count = var.enable_logs_to_log_analytics ? 1 : 0
#
#  name               = "logs-log-analytics"
#  target_resource_id = azurerm_mysql_server.mysql_server.id
#
#  log_analytics_workspace_id = var.logs_log_analytics_workspace_id
#
#  log {
#    category = "MySqlSlowLogs"
#
#    retention_policy {
#      enabled = false
#    }
#  }
#
#  log {
#    category = "MySqlAuditLogs"
#
#    retention_policy {
#      enabled = false
#    }
#  }
#
#  metric {
#    category = "AllMetrics"
#    enabled  = false
#
#    retention_policy {
#      enabled = false
#    }
#  }
#}
#