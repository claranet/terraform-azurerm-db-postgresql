resource "azurerm_postgresql_firewall_rule" "postgresql_rule" {
  name = "postgresql-rule-${replace(
    cidrhost(element(var.allowed_ip_addresses, count.index), 0),
    ".",
    "-",
  )}"
  count               = length(var.allowed_ip_addresses)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = cidrhost(element(var.allowed_ip_addresses, count.index), 0)
  end_ip_address      = cidrhost(element(var.allowed_ip_addresses, count.index), -1)
}
