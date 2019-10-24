resource "azurerm_postgresql_firewall_rule" "firewall_rules" {
  count               = length(var.firewall_rules)
  name                = lookup(var.firewall_rules[count.index], "name", count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = lookup(var.firewall_rules[count.index], "start_ip")
  end_ip_address      = lookup(var.firewall_rules[count.index], "end_ip")
}
