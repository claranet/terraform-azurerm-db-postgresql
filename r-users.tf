resource "random_password" "db_passwords" {
  count = var.create_databases_users ? length(var.databases_names) : 0

  special = "false"
  length  = 32
}

resource "null_resource" "db_users" {
  count = var.create_databases_users ? length(var.databases_names) : 0

  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars '{\"database_name\": ${element(var.databases_names, count.index)}, \"server_fqdn\": ${azurerm_postgresql_server.postgresql_server.fqdn}, \"administrator_user\": ${var.administrator_login}@${replace(azurerm_postgresql_server.postgresql_server.fqdn, ".postgres.database.azure.com", "")}, \"administrator_password\": ${var.administrator_password}, \"database_user_password\": ${random_password.db_passwords[count.index].result} }' --connection=local -i 127.0.0.1, main.yml"

    working_dir = "${path.module}/playbook-ansible"
  }

  triggers = {
    database = azurerm_postgresql_database.postgresql_db[count.index].id
  }

  depends_on = [azurerm_postgresql_server.postgresql_server, azurerm_postgresql_database.postgresql_db, random_password.db_passwords]
}