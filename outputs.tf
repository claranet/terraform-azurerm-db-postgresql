output "postgresql_administrator_login" {
  value       = "${azurerm_postgresql_server.postgresql_server.administrator_login}@${azurerm_postgresql_server.postgresql_server.name}"
  description = "Administrator login for PostgreSQL server"
}

output "postgresql_databases_names" {
  value       = azurerm_postgresql_database.postgresql_db.*.name
  description = "List of databases names"
}

output "postgresql_firewall_rule_ids" {
  value       = azurerm_postgresql_firewall_rule.postgresql_rule.*.id
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

