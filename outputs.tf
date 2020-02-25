output "postgresql_administrator_login" {
  value       = "${azurerm_postgresql_server.postgresql_server.administrator_login}@${azurerm_postgresql_server.postgresql_server.name}"
  description = "Administrator login for PostgreSQL server"
  sensitive   = true
}

output "postgresql_databases_names" {
  value       = azurerm_postgresql_database.postgresql_db.*.name
  description = "List of databases names"
}

output "postgresql_database_ids" {
  description = "The list of all database resource ids"
  value       = azurerm_postgresql_database.postgresql_db.*.id
}

output "postgresql_firewall_rule_ids" {
  value       = azurerm_postgresql_firewall_rule.firewall_rules.*.id
  description = "List of PostgreSQL created rules"
}

output "postgresql_fqdn" {
  value       = azurerm_postgresql_server.postgresql_server.fqdn
  description = "FQDN of the PostgreSQL server"
}

output "postgresql_server_id" {
  value       = azurerm_postgresql_server.postgresql_server.id
  description = "PostgreSQL server ID"
}

output "postgresql_vnet_rule_ids" {
  value       = azurerm_postgresql_virtual_network_rule.vnet_rules.*.ids
  description = "The list of all vnet rule resource ids"
}

output "postgresql_configuration_id" {
  value       = azurerm_postgresql_configuration.postgresql_config.*.id
  description = "The list of all configurations resource ids"
}
