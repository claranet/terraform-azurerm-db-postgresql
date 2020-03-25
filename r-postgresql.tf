resource "azurerm_postgresql_server" "postgresql_server" {
  name = coalesce(
    var.custom_server_name,
    local.default_name_server,
  )
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = join("_", [lookup(local.tier_map, var.tier, "GeneralPurpose"), "Gen5", var.capacity])

  storage_profile {
    storage_mb            = lookup(var.server_storage_profile, "storage_mb", null)
    backup_retention_days = lookup(var.server_storage_profile, "backup_retention_days", null)
    geo_redundant_backup  = lookup(var.server_storage_profile, "geo_redundant_backup", null)
    auto_grow             = lookup(var.server_storage_profile, "auto_grow", null)
  }

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  version                      = var.postgresql_version
  ssl_enforcement              = var.force_ssl ? "Enabled" : "Disabled"

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
