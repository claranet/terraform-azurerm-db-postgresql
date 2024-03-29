locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  postgresql_server_name = coalesce(var.custom_server_name, data.azurecaf_name.postgresql.result)
}
