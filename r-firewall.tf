resource "azurerm_postgresql_firewall_rule" "firewall_rules" {
  count               = length(var.allowed_cidrs)
  name                = replace(replace(var.allowed_cidrs[count.index], ".", "-"), "/", "_")
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  start_ip_address    = cidrhost(var.allowed_cidrs[count.index], 0)
  end_ip_address      = cidrhost(var.allowed_cidrs[count.index], -1)
}
