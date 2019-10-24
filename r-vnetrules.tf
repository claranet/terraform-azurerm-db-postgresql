resource "azurerm_postgresql_virtual_network_rule" "vnet_rules" {
  count               = length(var.vnet_rules)
  name                = lookup(var.vnet_rules[count.index], "name", count.index)
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  subnet_id           = lookup(var.vnet_rules[count.index], "subnet_id")
}
