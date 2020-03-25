output "postgresql_administrator_login" {
  value       = "${azurerm_postgresql_server.postgresql_server.administrator_login}@${azurerm_postgresql_server.postgresql_server.name}"
  description = "Administrator login for PostgreSQL server"
  sensitive   = true
}

output "postgresql_databases_names" {
  value       = azurerm_postgresql_database.postgresql_db
  description = "Map of databases names"
}

output "postgresql_database_ids" {
  description = "The map of all database resource ids"
  value       = azurerm_postgresql_database.postgresql_db
}

output "postgresql_firewall_rules" {
  value       = azurerm_postgresql_firewall_rule.firewall_rules
  description = "Map of PostgreSQL created rules"
}

output "postgresql_fqdn" {
  value       = azurerm_postgresql_server.postgresql_server.fqdn
  description = "FQDN of the PostgreSQL server"
}

output "postgresql_server_id" {
  value       = azurerm_postgresql_server.postgresql_server.id
  description = "PostgreSQL server ID"
}

output "postgresql_vnet_rules" {
  value       = azurerm_postgresql_virtual_network_rule.vnet_rules
  description = "The map of all vnet rules"
}

output "postgresql_configurations" {
  value       = azurerm_postgresql_configuration.postgresql_config
  description = "The map of all postgresql configurations set"
}

output "postgresql_users_passwords" {
  value       = random_password.db_passwords
  description = "Map of passwords for databases users"
  sensitive   = true
}
