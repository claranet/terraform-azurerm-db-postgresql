resource "azurerm_postgresql_firewall_rule" "firewall_rules" {
  for_each            = var.allowed_cidrs
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = cidrhost(each.value, 0)
  end_ip_address      = cidrhost(each.value, -1)
}
