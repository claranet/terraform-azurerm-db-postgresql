provider "postgresql" {
  host      = azurerm_postgresql_server.postgresql_server.fqdn
  port      = 5432
  username  = format("%s@%s", var.administrator_login, local.postgresql_server_name)
  password  = var.administrator_password
  sslmode   = "require"
  superuser = false

  alias = "create_users"
}
