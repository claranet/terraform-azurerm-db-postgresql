# Azure Managed PostgreSQL Service

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/db-postgresql/azurerm/)

This module creates an [Azure PostgreSQL server](https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html) with [databases](https://www.terraform.io/docs/providers/azurerm/r/postgresql_database.html) along with logging activated and [firewall rules](https://www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html) and [virtual network rules](https://www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html).
A user is created for each databases created with this module. This module does not allow users to create new objects in the public schema regarding the [CVE-2018-1058](https://wiki.postgresql.org/wiki/A_Guide_to_CVE-2018-1058%3A_Protect_Your_Search_Path#Do_not_allow_users_to_create_new_objects_in_the_public_schema).

## Requirements

* [Ansible](https://docs.ansible.com/ansible/latest/index.html) >= 2.4
* Library [libpq-dev](https://pypi.org/project/libpq-dev/) and PostgreSQL adapter [python-psycopg2](https://pypi.org/project/psycopg2/)

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 4.x.x       | 0.13.x            | >= 2.7          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "postgresql" {
  source  = "claranet/db-postgresql/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  environment         = var.environment
  stack               = var.stack

  tier     = "GeneralPurpose"
  capacity = 4

  allowed_cidrs = {
    "1" = "10.0.0.0/24"
    "2" = "12.34.56.78/32"
  }

  
  storage_mb                    = 5120
  backup_retention_days         = 10
  geo_redundant_backup_enabled  = true
  auto_grow_enabled             = false
  
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  force_ssl = true

  databases_names     = ["mydatabase"]
  databases_collation = { mydatabase = "en-US" }
  databases_charset   = { mydatabase = "UTF8" }

  extra_tags = var.extra_tags
}
```

## Providers

| Name    | Version |
| ------- | ------- |
| azurerm | >= 2.7  |
| null    | >= 3.0  |
| random  | >= 3.0  |

## Inputs

| Name                                 | Description                                                                                                                                                                                              | Type           | Default            | Required |
| ------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | ------------------ | :------: |
| administrator\_login                 | PostgreSQL administrator login                                                                                                                                                                           | `string`       | n/a                |   yes    |
| administrator\_password              | PostgreSQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017                                            | `string`       | n/a                |   yes    |
| allowed\_cidrs                       | Map of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state                                                                                        | `map(string)`  | n/a                |   yes    |
| auto\_grow\_enabled                  | Enable/Disable auto-growing of the storage.                                                                                                                                                              | `bool`         | `false`            |    no    |
| backup\_retention\_days              | Backup retention days for the server, supported values are between 7 and 35 days.                                                                                                                        | `number`       | `10`               |    no    |
| capacity                             | Capacity for PostgreSQL server sku - number of vCores : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers                                                                         | `number`       | `4`                |    no    |
| client\_name                         | Name of client                                                                                                                                                                                           | `string`       | n/a                |   yes    |
| create\_databases\_users             | True to create a user named <db>\_user per database with generated password and role db\_owner.                                                                                                          | `bool`         | `true`             |    no    |
| custom\_server\_name                 | Custom Server Name identifier                                                                                                                                                                            | `string`       | `""`               |    no    |
| databases\_charset                   | Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE                                                                                                          | `map(string)`  | `{}`               |    no    |
| databases\_collation                 | Valid PostgreSQL collation : http://www.postgresql.cn/docs/9.4/collation.html - be careful about https://docs.microsoft.com/en-us/windows/win32/intl/locale-names?redirectedfrom=MSDN                    | `map(string)`  | `{}`               |    no    |
| databases\_names                     | List of databases names                                                                                                                                                                                  | `list(string)` | n/a                |   yes    |
| enable\_logs\_to\_log\_analytics     | Boolean flag to specify whether the logs should be sent to Log Analytics                                                                                                                                 | `bool`         | `false`            |    no    |
| enable\_logs\_to\_storage            | Boolean flag to specify whether the logs should be sent to the Storage Account                                                                                                                           | `bool`         | `false`            |    no    |
| environment                          | Name of application's environnement                                                                                                                                                                      | `string`       | n/a                |   yes    |
| extra\_tags                          | Map of custom tags                                                                                                                                                                                       | `map(string)`  | `{}`               |    no    |
| force\_ssl                           | Force usage of SSL                                                                                                                                                                                       | `bool`         | `true`             |    no    |
| geo\_redundant\_backup\_enabled      | Turn Geo-redundant server backups on/off. Not available for the Basic tier.                                                                                                                              | `bool`         | `true`             |    no    |
| location                             | Azure location for Key Vault.                                                                                                                                                                            | `string`       | n/a                |   yes    |
| location\_short                      | Short string for Azure location.                                                                                                                                                                         | `string`       | n/a                |   yes    |
| logs\_log\_analytics\_workspace\_id  | Log Analytics Workspace id for logs                                                                                                                                                                      | `string`       | `""`               |    no    |
| logs\_storage\_account\_id           | Storage Account id for logs                                                                                                                                                                              | `string`       | `""`               |    no    |
| name\_prefix                         | Optional prefix for PostgreSQL server name                                                                                                                                                               | `string`       | `""`               |    no    |
| postgresql\_configurations           | PostgreSQL configurations to enable                                                                                                                                                                      | `map(string)`  | `{}`               |    no    |
| postgresql\_version                  | Valid values are 9.5, 9.6, 10, 10.0, and 11                                                                                                                                                              | `string`       | `"11"`             |    no    |
| resource\_group\_name                | Name of the application ressource group, herited from infra module                                                                                                                                       | `string`       | n/a                |   yes    |
| ssl\_minimal\_tls\_version\_enforced | The mimimun TLS version to support on the sever                                                                                                                                                          | `string`       | `null`             |    no    |
| stack                                | Name of application stack                                                                                                                                                                                | `string`       | n/a                |   yes    |
| storage\_mb                          | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs. | `number`       | `5120`             |    no    |
| tier                                 | Tier for PostgreSQL server sku : https://docs.microsoft.com/en-us/azure/postgresql/concepts-pricing-tiers Possible values are: GeneralPurpose, Basic, MemoryOptimized                                    | `string`       | `"GeneralPurpose"` |    no    |
| vnet\_rules                          | Map of vnet rules to create                                                                                                                                                                              | `map(string)`  | `{}`               |    no    |

## Outputs

| Name                             | Description                                  |
| -------------------------------- | -------------------------------------------- |
| postgresql\_administrator\_login | Administrator login for PostgreSQL server    |
| postgresql\_configurations       | The map of all postgresql configurations set |
| postgresql\_database\_ids        | The map of all database resource ids         |
| postgresql\_databases\_names     | Map of databases names                       |
| postgresql\_firewall\_rules      | Map of PostgreSQL created rules              |
| postgresql\_fqdn                 | FQDN of the PostgreSQL server                |
| postgresql\_server\_id           | PostgreSQL server ID                         |
| postgresql\_users\_passwords     | Map of passwords for databases users         |
| postgresql\_vnet\_rules          | The map of all vnet rules                    |

## Related documentation

Terraform Azure PostgreSQL Server documentation: [www.terraform.io/docs/providers/azurerm/r/postgresql_server.html](https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html)

Terraform Azure PostgreSQL Database documentation: [www.terraform.io/docs/providers/azurerm/r/postgresql_database.html](https://www.terraform.io/docs/providers/azurerm/r/postgresql_database.html)

Terraform Azure PostgreSQL Virtual Network Rule documentation: [www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html](https://www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html)

Terraform Azure PostgreSQL Firewall documentation: [www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html](https://www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html)

Terraform Azure PostgreSQL Configuration documentation: [www.terraform.io/docs/providers/azurerm/r/postgresql_configuration.htmlhttps://www.terraform.io/docs/providers/azurerm/r/postgresql_configuration.html](https://www.terraform.io/docs/providers/azurerm/r/postgresql_configuration.htmlhttps://www.terraform.io/docs/providers/azurerm/r/postgresql_configuration.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/postgresql/overview](https://docs.microsoft.com/en-us/azure/postgresql/overview)