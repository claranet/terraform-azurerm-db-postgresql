# Azure Managed PostgreSQL Service

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/db-postgresql/azurerm/)

This module creates an [Azure PostgreSQL server](https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html) with [databases](https://www.terraform.io/docs/providers/azurerm/r/postgresql_database.html) along with logging activated and [firewall rules](https://www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html) and [virtual network rules](https://www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html).

## Requirements

* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.31

## Terraform version compatibility
 
| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

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

  server_sku = {
    name     = "GP_Gen5_8"
    capacity = 4
    tier     = "GeneralPurpose"
    family   = "Gen5"
  }

  server_storage_profile = {
    storage_mb            = 5120
    backup_retention_days = 10
    geo_redundant_backup  = "Enabled"
    auto_grow             = "Disabled"
  }

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  allowed_ip_addresses = ["x.x.x.x/32"]

  databases_names     = ["mydatabase"]
  databases_collation = { mydatabase = "en_US" }
  databases_charset   = { mydatabase = "UTF8" }

  enable_logs_to_storage          = "true"
  enable_logs_to_log_analytics    = "true"
  logs_storage_account_id         = data.terraform_remote_state.run.outputs.logs_storage_account_id
  logs_log_analytics_workspace_id = data.terraform_remote_state.run.outputs.log_analytics_workspace_id
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| administrator\_login | PostgreSQL administrator login | string | n/a | yes |
| administrator\_password | PostgreSQL administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017 | string | n/a | yes |
| allowed\_ip\_addresses | List of authorized cidrs, must be provided using remote states cloudpublic/cloudpublic/global/vars/terraform.state | list(string) | n/a | yes |
| client\_name | Name of client | string | n/a | yes |
| custom\_server\_name | Custom Server Name identifier | string | `""` | no |
| databases\_charset | Valid PostgreSQL charset : https://www.postgresql.org/docs/current/multibyte.html#CHARSET-TABLE | map(string) | n/a | yes |
| databases\_collation | Valid PostgreSQL collation : http://www.postgresql.cn/docs/9.4/collation.html - be careful about https://docs.microsoft.com/en-us/windows/win32/intl/locale-names?redirectedfrom=MSDN | map(string) | n/a | yes |
| databases\_names | List of databases names | list(string) | n/a | yes |
| enable\_logs\_to\_log\_analytics | Boolean flag to specify whether the logs should be sent to Log Analytics | string | `"false"` | no |
| enable\_logs\_to\_storage | Boolean flag to specify whether the logs should be sent to the Storage Account | string | `"false"` | no |
| environment | Name of application's environnement | string | n/a | yes |
| extra\_tags | Map of custom tags | map(string) | `{}` | no |
| firewall\_rules | List of firewall rules to create | list(map(string)) | `[]` | no |
| location | Azure location for Key Vault. | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| logs\_log\_analytics\_workspace\_id | Log Analytics Workspace id for logs | string | `""` | no |
| logs\_storage\_account\_id | Storage Account id for logs | string | `""` | no |
| logs\_storage\_retention | Retention in days for logs on Storage Account | string | `"30"` | no |
| name\_prefix | Optional prefix for PostgreSQL server name | string | `""` | no |
| postgresql\_configurations | PostgreSQL configurations to enable | list(map(string)) | `[]` | no |
| postgresql\_version | Valid values are 9.5, 9.6, 10, 10.0, and 11 | string | `"11"` | no |
| resource\_group\_name | Name of the application ressource group, herited from infra module | string | n/a | yes |
| server\_sku | Server class : https://www.terraform.io/docs/providers/azurerm/r/postgresql\_server.html#sku | map(string) | `{ "capacity": 4, "family": "Gen5", "name": "GP_Gen5_8", "tier": "GeneralPurpose" }` | no |
| server\_storage\_profile | Storage configuration : https://www.terraform.io/docs/providers/azurerm/r/postgresql\_server.html#storage\_profile | map(string) | `{ "auto_grow": "", "backup_retention_days": 10, "geo_redundant_backup": "Enabled", "storage_mb": 5120 }` | no |
| ssl\_enforcement | Possible values are Enforced and Disabled | string | `"Enabled"` | no |
| stack | Name of application stack | string | n/a | yes |
| vnet\_rules | List of vnet rules to create | list(map(string)) | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| postgresql\_administrator\_login | Administrator login for PostgreSQL server |
| postgresql\_configuration\_id | The list of all configurations resource ids |
| postgresql\_database\_ids | The list of all database resource ids |
| postgresql\_databases\_names | List of databases names |
| postgresql\_firewall\_rule\_ids | List of PostgreSQL created rules |
| postgresql\_fqdn | FQDN of the PostgreSQL server |
| postgresql\_server\_id | PostgreSQL server ID |
| postgresql\_vnet\_rule\_ids | The list of all vnet rule resource ids |

## Related documentation

Terraform Azure PostgreSQL Server documentation: [https://www.terraform.io/docs/providers/azurerm/r/postgresql_server.html]

Terraform Azure PostgreSQL Database documentation: [https://www.terraform.io/docs/providers/azurerm/r/postgresql_database.html]

Terraform Azure PostgreSQL Virtual Network Rule documentation: [https://www.terraform.io/docs/providers/azurerm/r/postgresql_virtual_network_rule.html]

Terraform Azure PostgreSQL Firewall documentation: [https://www.terraform.io/docs/providers/azurerm/r/postgresql_firewall_rule.html]

Terraform Azure PostgreSQL Configuration documentation: [https://www.terraform.io/docs/providers/azurerm/r/postgresql_configuration.htmlhttps://www.terraform.io/docs/providers/azurerm/r/postgresql_configuration.html]

Microsoft Azure documentation: [https://docs.microsoft.com/fr-fr/azure/postgresql/overview]