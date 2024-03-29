# DEPRECATED - Azure Managed PostgreSQL Service

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/db-postgresql/azurerm/)

| ⚠ This module is deprecated, please use [db-postgresql-flexible](https://registry.terraform.io/modules/claranet/db-postgresql-flexible/azurerm/) module |
|--|

This module creates an [Azure PostgreSQL server](https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html)
with [databases](https://www.terraform.io/docs/providers/azurerm/r/postgresql_database.html) along with logging activated,
[firewall rules](https://www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html) and
[virtual network rules](https://www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html).

A user is created for each database created with this module. This module does not allow users to create new objects in
the public schema regarding the [CVE-2018-1058](https://wiki.postgresql.org/wiki/A_Guide_to_CVE-2018-1058%3A_Protect_Your_Search_Path#Do_not_allow_users_to_create_new_objects_in_the_public_schema).

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "logs" {
  source  = "claranet/run-common/azurerm//modules/logs"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

resource "random_password" "admin_password" {
  special = "false"
  length  = 32
}

module "postgresql" {
  source  = "claranet/db-postgresql/azurerm"
  version = "x.x.x"

  client_name    = var.client_name
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  environment    = var.environment
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name

  tier     = "GeneralPurpose"
  capacity = 4

  allowed_cidrs = {
    "1" = "10.0.0.0/24"
    "2" = "12.34.56.78/32"
  }

  storage_mb                   = 5120
  backup_retention_days        = 10
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = false

  administrator_login    = "azureadmin"
  administrator_password = random_password.admin_password.result

  force_ssl = true

  databases_names     = ["mydatabase"]
  databases_collation = { mydatabase = "en-US" }
  databases_charset   = { mydatabase = "UTF8" }

  logs_destinations_ids = [
    module.logs.logs_storage_account_id,
    module.logs.log_analytics_workspace_id
  ]

  extra_tags = {
    foo = "bar"
  }
}

provider "postgresql" {
  host      = module.postgresql.postgresql_fqdn
  port      = 5432
  username  = module.postgresql.postgresql_administrator_login
  password  = module.postgresql.postgresql_administrator_password
  sslmode   = "require"
  superuser = false
}

module "postgresql_users" {
  source  = "claranet/users/postgresql"
  version = "x.x.x"

  for_each = toset(module.postgresql.postgresql_databases_names)

  administrator_login = module.postgresql.postgresql_administrator_login

  database = each.key
}

module "postgresql_configuration" {
  source  = "claranet/database-configuration/postgresql"
  version = "x.x.x"

  for_each = toset(module.postgresql.postgresql_databases_names)

  administrator_login = module.postgresql.postgresql_administrator_login

  database_admin_user = module.postgresql_users[each.key].user
  database            = each.key
  schema_name         = each.key
}
```

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | >= 3.22 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| diagnostics | claranet/diagnostic-settings/azurerm | 6.2.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_postgresql_configuration.postgresql_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_configuration) | resource |
| [azurerm_postgresql_database.postgresql_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database) | resource |
| [azurerm_postgresql_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_firewall_rule) | resource |
| [azurerm_postgresql_server.postgresql_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server) | resource |
| [azurerm_postgresql_virtual_network_rule.vnet_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_virtual_network_rule) | resource |
| [azurecaf_name.postgresql](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.postgresql_dbs](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | PostgreSQL administrator login | `string` | n/a | yes |
| administrator\_password | PostgreSQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017 | `string` | n/a | yes |
| allowed\_cidrs | Map of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state | `map(string)` | n/a | yes |
| auto\_grow\_enabled | Enable/Disable auto-growing of the storage. | `bool` | `false` | no |
| backup\_retention\_days | Backup retention days for the server, supported values are between 7 and 35 days. | `number` | `10` | no |
| capacity | Capacity for PostgreSQL server sku - number of vCores : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers | `number` | `4` | no |
| client\_name | Name of client | `string` | n/a | yes |
| custom\_diagnostic\_settings\_name | Custom name of the diagnostics settings, name will be 'default' if not set. | `string` | `"default"` | no |
| custom\_server\_name | Custom Server Name identifier | `string` | `""` | no |
| databases\_charset | Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE | `map(string)` | `{}` | no |
| databases\_collation | Valid PostgreSQL collation : http://www.postgresql.cn/docs/9.4/collation.html - be careful about https://docs.microsoft.com/en-us/windows/win32/intl/locale-names?redirectedfrom=MSDN | `map(string)` | `{}` | no |
| databases\_names | List of databases names | `list(string)` | n/a | yes |
| default\_tags\_enabled | Option to enable or disable default tags | `bool` | `true` | no |
| environment | Name of application's environnement | `string` | n/a | yes |
| extra\_tags | Extra tags to add | `map(string)` | `{}` | no |
| force\_ssl | Force usage of SSL | `bool` | `true` | no |
| geo\_redundant\_backup\_enabled | Turn Geo-redundant server backups on/off. Not available for the Basic tier. | `bool` | `true` | no |
| location | Azure location for Key Vault. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| logs\_categories | Log categories to send to destinations. | `list(string)` | `null` | no |
| logs\_destinations\_ids | List of destination resources IDs for logs diagnostic destination.<br>Can be `Storage Account`, `Log Analytics Workspace` and `Event Hub`. No more than one of each can be set.<br>If you want to specify an Azure EventHub to send logs and metrics to, you need to provide a formated string with both the EventHub Namespace authorization send ID and the EventHub name (name of the queue to use in the Namespace) separated by the `|` character. | `list(string)` | n/a | yes |
| logs\_metrics\_categories | Metrics categories to send to destinations. | `list(string)` | `null` | no |
| logs\_retention\_days | Number of days to keep logs on storage account. | `number` | `30` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| postgresql\_configurations | PostgreSQL configurations to enable | `map(string)` | `{}` | no |
| postgresql\_version | Valid values are 9.5, 9.6, 10, 10.0, and 11 | `string` | `"11"` | no |
| public\_network\_access\_enabled | Whether or not public network access is allowed for this server. | `bool` | `false` | no |
| resource\_group\_name | Name of the application ressource group, herited from infra module | `string` | n/a | yes |
| ssl\_minimal\_tls\_version\_enforced | The mimimun TLS version to support on the sever | `string` | `null` | no |
| stack | Name of application stack | `string` | n/a | yes |
| storage\_mb | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs. | `number` | `5120` | no |
| tier | Tier for PostgreSQL server sku : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers Possible values are: GeneralPurpose, Basic, MemoryOptimized | `string` | `"GeneralPurpose"` | no |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_server_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_caf\_naming\_for\_databases | Use the Azure CAF naming provider to generate databases name. | `bool` | `false` | no |
| vnet\_rules | Map of vnet rules to create | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| postgresql\_administrator\_login | Administrator login for PostgreSQL server |
| postgresql\_administrator\_password | Administrator password for PostgreSQL server |
| postgresql\_configurations | The map of all postgresql configurations set |
| postgresql\_database\_ids | The map of all database resource ids |
| postgresql\_databases\_names | Map of databases names |
| postgresql\_firewall\_rules | Map of PostgreSQL created rules |
| postgresql\_fqdn | FQDN of the PostgreSQL server |
| postgresql\_server\_id | PostgreSQL server ID |
| postgresql\_server\_name | PostgreSQL server name |
| postgresql\_vnet\_rules | The map of all vnet rules |
| terraform\_module | Information about this Terraform module |
<!-- END_TF_DOCS -->
## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/postgresql/overview](https://docs.microsoft.com/en-us/azure/postgresql/overview)
