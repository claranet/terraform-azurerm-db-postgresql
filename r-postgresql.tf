resource "azurerm_postgresql_server" "postgresql_server" {
  name = coalesce(
    var.custom_server_name,
    local.default_name_server,
  )
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), "Gen5", var.capacity])

  storage_mb                   = var.storage_mb
  backup_retention_days        = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  auto_grow_enabled            = var.auto_grow_enabled

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  version                      = var.postgresql_version
  ssl_enforcement_enabled      = var.force_ssl

  tags = merge(
    {
      "env"   = var.environment
      "stack" = var.stack
    },
    var.extra_tags,
  )
}

resource "azurerm_postgresql_database" "postgresql_db" {
  for_each            = toset(var.databases_names)
  name                = each.value
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  charset             = lookup(var.databases_charset, each.value, "UTF8")
  collation           = lookup(var.databases_collation, each.value, "en-US")
}

resource "azurerm_postgresql_configuration" "postgresql_config" {
  for_each            = var.postgresql_configurations
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgresql_server.name
  value               = each.value
}
