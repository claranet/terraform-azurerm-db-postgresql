# Azure Database - Managed PostgreSQL

This feature is a wrapper on top of the official Microsoft terraform module, available at https://registry.terraform.io/modules/Azure/postgresql/azurerm/ (https://github.com/Azure/terraform-azurerm-postgresql/)

It will set Claranet defaults values and input variables names with Claranet best practices.

## How to

```shell
module "postgresql" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/db-postgresql.git?ref=xxx"

  client_name                  = "${var.client_name}"
  location                     = "${module.az-regions.location}"
  location_short               = "${module.az-regions.location-short}"
  environment                  = "${var.environment}"
  stack                        = "${var.stack}"

  # Mandatory variables
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| administrator_login | The Administrator Login for the PostgreSQL Server. Changing this forces a new resource to be created. | string | `claranet` | no |
| administrator_password | The Password associated with the administrator_login for the PostgreSQL Server. | string | - | yes |
| backup_retention_days | Backup retention days for the server, supported values are between 7 and 35 days. | string | `7` | no |
| client_name | Client name/account used in naming | string | - | yes |
| db_charset | Specifies the Charset for the PostgreSQL Database, which needs to be a valid PostgreSQL Charset. Changing this forces a new resource to be created. | string | `UTF8` | no |
| db_collation | Specifies the Collation for the PostgreSQL Database, which needs to be a valid PostgreSQL Collation. Changing this forces a new resource to be created. | string | `English_United States.1252` | no |
| db_names | The list of names of the PostgreSQL Database, which needs to be a valid PostgreSQL identifier. Changing this forces a new resource to be created. | list | `<list>` | no |
| environment | Project environment | string | - | yes |
| firewall_rule_prefix | Specifies prefix for firewall rule names. | string | `firewall-` | no |
| firewall_rules | The list of maps, describing firewall rules. Valid map items: name, start_ip, end_ip. | list | `<list>` | no |
| geo_redundant_backup | Enable Geo-redundant or not for server backup. Valid values for this property are Enabled or Disabled, not supported for the basic tier. | string | `Disabled` | no |
| location | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | string | - | yes |
| location_short | Short version of the Azure location, used by naming convention. | string | - | yes |
| postgresql_configurations | A map with PostgreSQL configurations to enable. | map | `<map>` | no |
| resource_group_name | The name of the resource group in which to create the PostgreSQL Server. Changing this forces a new resource to be created. | string | - | yes |
| server_name | Specifies the name of the PostgreSQL Server. Changing this forces a new resource to be created. | string | `` | no |
| server_version | Specifies the version of PostgreSQL to use. Valid values are 9.5, 9.6, and 10.0. Changing this forces a new resource to be created. | string | `10.0` | no |
| sku_capacity | The scale up/out capacity, representing server's compute units | string | `2` | no |
| sku_family | The family of hardware Gen4 or Gen5. | string | `Gen5` | no |
| sku_name | Specifies the SKU Name for this PostgreSQL Server. The name of the SKU, follows the tier + family + cores pattern (e.g. B_Gen4_1, GP_Gen5_8). | string | `GP_Gen5_2` | no |
| sku_tier | The tier of the particular SKU. Possible values are Basic, GeneralPurpose, and MemoryOptimized. | string | `GeneralPurpose` | no |
| ssl_enforcement | Specifies if SSL should be enforced on connections. Possible values are Enabled and Disabled. | string | `Enabled` | no |
| stack | Project stack name | string | - | yes |
| storage_mb | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs. | string | `5120` | no |
| tags | A map of tags to set on every resources. Empty by default. | map | `<map>` | no |
| vnet_rule_name_prefix | Specifies prefix for vnet rule names. | string | `postgresql-vnet-rule-` | no |
| vnet_rules | The list of maps, describing vnet rules. Valud map items: name, subnet_id. | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| administrator_login | PostgreSQL global server administrator login |
| administrator_password | PostgreSQL global server administrator password |
| database_ids | The list of all database resource ids |
| firewall_rule_ids | The list of all firewall rule resource ids |
| server_fqdn | The fully qualified domain name (FQDN) of the PostgreSQL server |
| server_id | The resource id of the PostgreSQL server |
| server_name | The name of the PostgreSQL server |
| vnet_rule_ids | The list of all vnet rule resource ids |
