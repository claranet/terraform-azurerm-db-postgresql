output "server_name" {
  description = "The name of the PostgreSQL server"
  value       = "${module.postgresql.server_name}"
}

output "server_fqdn" {
  description = "The fully qualified domain name (FQDN) of the PostgreSQL server"
  value       = "${module.postgresql.server_fqdn}"
}

output "administrator_login" {
  value = "${var.administrator_login}"
}

output "administrator_password" {
  value     = "${var.administrator_password}"
  sensitive = true
}

output "server_id" {
  description = "The resource id of the PostgreSQL server"
  value       = "${module.postgresql.server_id}"
}

output "database_ids" {
  description = "The list of all database resource ids"
  value       = ["${module.postgresql.database_ids}"]
}

output "firewall_rule_ids" {
  description = "The list of all firewall rule resource ids"
  value       = ["${module.postgresql.firewall_rule_ids}"]
}

output "vnet_rule_ids" {
  description = "The list of all vnet rule resource ids"
  value       = ["${module.postgresql.vnet_rule_ids}"]
}
