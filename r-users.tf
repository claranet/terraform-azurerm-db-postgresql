resource "random_password" "db_passwords" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  special = "false"
  length  = 32
}

resource "postgresql_role" "db_user" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  name        = format("%s_user", each.value)
  login       = true
  password    = random_password.db_passwords[each.value].result
  create_role = true
  roles       = []
  search_path = []

  provider = postgresql.psql
}

resource "postgresql_grant" "revoke_public" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  database    = each.value
  role        = "public"
  schema      = "public"
  object_type = "schema"
  privileges  = []

  provider = postgresql.psql

}

resource "postgresql_schema" "db_schema" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  name     = each.value
  database = each.value
}

resource "postgresql_default_privileges" "user_tables_priviliges" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  role     = format("%s_user", each.value)
  database = each.value
  schema   = each.value

  object_type = "table"
  owner       = var.administrator_login
  privileges = [
    "SELECT",
    "INSERT",
    "UPDATE",
    "DELETE",
    "TRUNCATE",
    "REFERENCES",
    "TRIGGER",
    # "CREATE",
    # "CONNECT",
    # "TEMPORARY",
    # "EXECUTE",
    # "USAGE",
  ]

  provider = postgresql.psql
}

resource "postgresql_default_privileges" "user_sequences_priviliges" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  role     = format("%s_user", each.value)
  database = each.value
  schema   = each.value

  object_type = "sequence"
  owner       = var.administrator_login
  privileges = [
    "SELECT",
    # "INSERT",
    "UPDATE",
    # "DELETE",
    # "TRUNCATE",
    # "REFERENCES",
    # "TRIGGER",
    # "CREATE",
    # "CONNECT",
    # "TEMPORARY",
    # "EXECUTE",
    "USAGE",
  ]

  provider = postgresql.psql
}
# ALTER DEFAULT PRIVILEGES IN SCHEMA {{ database_name }} GRANT ALL PRIVILEGES ON SEQUENCES TO {{ database_name }}_user;

resource "postgresql_default_privileges" "user_functions_priviliges" {
  for_each = var.create_databases_users ? toset(var.databases_names) : toset([])

  role     = format("%s_user", each.value)
  database = each.value
  schema   = each.value

  object_type = "function"
  owner       = var.administrator_login
  privileges = [
    # "SELECT",
    # "INSERT",
    # "UPDATE",
    # "DELETE",
    # "TRUNCATE",
    # "REFERENCES",
    # "TRIGGER",
    # "CREATE",
    # "CONNECT",
    # "TEMPORARY",
    "EXECUTE",
    # "USAGE",
  ]

  provider = postgresql.psql
}
