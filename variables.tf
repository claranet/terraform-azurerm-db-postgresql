variable "client_name" {
  description = "Name of client"
  type        = string
}

variable "environment" {
  description = "Name of application's environnement"
  type        = string
}

variable "stack" {
  description = "Name of application stack"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the application ressource group, herited from infra module"
  type        = string
}

variable "location" {
  description = "Azure location for Key Vault."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "name_prefix" {
  description = "Optional prefix for PostgreSQL server name"
  type        = string
  default     = ""
}

variable "custom_server_name" {
  type        = string
  description = "Custom Server Name identifier"
  default     = ""
}

variable "administrator_login" {
  description = "PostgreSQL administrator login"
  type        = string
}

variable "administrator_password" {
  description = "PostgreSQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017"
  type        = string
}

variable "allowed_ip_addresses" {
  type        = list(string)
  description = "List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state"
}

variable "extra_tags" {
  type        = map(string)
  description = "Map of custom tags"
  default     = {}
}

variable "server_sku" {
  type = map(string)

  default = {
    name     = "GP_Gen5_8"
    capacity = 4
    tier     = "GeneralPurpose"
    family   = "Gen5"
  }

  description = "Server class : https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html#sku"
}

variable "server_storage_profile" {
  type = map(string)

  default = {
    storage_mb            = 5120
    backup_retention_days = 10
    geo_redundant_backup  = "Enabled"
    auto_grow             = ""
  }

  description = "Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html#storage_profile"
}

variable "postgresql_configurations" {
  type        = list(map(string))
  default     = []
  description = " PostgreSQL configurations to enable"
}

variable "postgresql_version" {
  default     = "11"
  description = "Valid values are 9.5, 9.6, 10, 10.0, and 11"
}

variable "ssl_enforcement" {
  default     = "Enabled"
  description = "Possible values are Enforced and Disabled"
}

variable "vnet_rules" {
  type        = list(map(string))
  description = "List of vnet rules to create"
  default     = []
}

variable "firewall_rules" {
  type        = list(map(string))
  description = "List of firewall rules to create"
  default     = []
}

variable "databases_names" {
  description = "List of databases names"
  type        = list(string)
}

variable "databases_charset" {
  type        = map(string)
  description = "Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE"
}

variable "databases_collation" {
  type        = map(string)
  description = "Valid PostgreSQL collation : http://www.postgresql.cn/docs/9.4/collation.html - be careful about https://docs.microsoft.com/en-us/windows/win32/intl/locale-names?redirectedfrom=MSDN"
}

variable "enable_logs_to_storage" {
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account"
  type        = string
  default     = "false"
}

variable "enable_logs_to_log_analytics" {
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics"
  type        = string
  default     = "false"
}

variable "logs_storage_retention" {
  description = "Retention in days for logs on Storage Account"
  type        = string
  default     = "30"
}

variable "logs_storage_account_id" {
  description = "Storage Account id for logs"
  type        = string
  default     = ""
}

variable "logs_log_analytics_workspace_id" {
  description = "Log Analytics Workspace id for logs"
  type        = string
  default     = ""
}

