module "postgresql" {
  source = "Azure/postgresql/azurerm"

  resource_group_name = "${var.resource_group_name}"
  location            = "${var.azure_region}"

  server_name  = "${coalesce(var.server_name, "psql-${var.environment}-${var.azure_short_region}-${var.client_name}-${var.stack}")}"
  sku_name     = "${var.sku_name}"
  sku_capacity = "${var.sku_capacity}"
  sku_tier     = "${var.sku_tier}"
  sku_family   = "${var.sku_family}"

  storage_mb            = "${var.storage_mb}"
  backup_retention_days = "${var.backup_retention_days}"
  geo_redundant_backup  = "${var.geo_redundant_backup}"

  administrator_login    = "${var.administrator_login}"
  administrator_password = "${var.administrator_password}"

  server_version  = "${var.server_version}"
  ssl_enforcement = "${var.ssl_enforcement}"

  db_names     = "${var.db_names}"
  db_charset   = "${var.db_charset}"
  db_collation = "${var.db_collation}"

  firewall_rule_prefix = "${var.firewall_rule_prefix}"
  firewall_rules       = "${var.firewall_rules}"

  vnet_rule_name_prefix = "${var.vnet_rule_name_prefix}"
  vnet_rules            = "${var.vnet_rules}"
}
