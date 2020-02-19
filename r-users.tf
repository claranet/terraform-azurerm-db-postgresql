resource "random_password" "db_passwords" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  special = "false"
  length  = 32
}

resource "null_resource" "db_users" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars '{\"database_name\": ${each.value}, \"server_fqdn\": ${azurerm_postgresql_server.postgresql_server.fqdn}, \"administrator_user\": ${var.administrator_login}@${replace(azurerm_postgresql_server.postgresql_server.fqdn, ".postgres.database.azure.com", "")}, \"administrator_password\": ${var.administrator_password}, \"database_user_password\": ${random_password.db_passwords[each.value].result} }' --connection=local -i 127.0.0.1, main.yml"

    working_dir = "${path.module}/playbook-ansible"
  }

  triggers = {
    database = azurerm_postgresql_database.postgresql_db[each.value].id
  }

  depends_on = [azurerm_postgresql_server.postgresql_server, azurerm_postgresql_database.postgresql_db, random_password.db_passwords]
}
