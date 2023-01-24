# v6.1.0 - 2023-01-24

Breaking
  * AZ-930: Externalize `postgresql-users` and `postgresql-database-configuration` as separated modules in dedicated repo

# v6.0.0 - 2022-11-25

Breaking
  * AZ-839: Require Terraform 1.1+ and AzureRM provider `v3.22+`

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v5.2.0 - 2022-11-10

Changed
  * AZ-901: Change default value for `public_network_access_enabled` variable to `false`
  * AZ-901: Add PostgreSQL configuration for logging connections and checkpoints, and enable connection throttling

# v5.1.0 - 2022-07-01

Added
  * AZ-770: Add Terraform module info in output

# v5.0.0 - 2022-02-18

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources
  * AZ-589: Add `diagnostic settings` module (latest v5.0.0)
  * AZ-501: Replace ansible with postgresql provider for user creation

Added
  * AZ-615: Add an option to enable or disable default tags

Changed
  * AZ-572: Revamp examples and improve CI

# v4.1.1 - 2021-08-20

Updated
  * AZ-532: Revamp README with latest `terraform-docs` tool

# v4.1.0 - 2021-08-18

Added
  * AZ-544: Add `ssl_minimal_tls_version_enforce` parameter

Fixed
  * AZ-530: Cleanup module and fix linter errors

# v4.0.2 - 2021-07-21

Fixed
  * AZ-529: Fix AzureRM minimum version required

# v4.0.1 - 2021-07-07

Changed
  * AZ-518: Fix README 

# v4.0.0 - 2021-01-18

Changed
  * AZ-398: Force lowercase on default generated name

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.0.0 - 2020-07-27

Breaking
  * AZ-198: Upgrade for compatibility AzureRM 2.0

# v2.1.0 - 2020-07-09

Breaking
  * AZ-206: Pin and fix minimal version of AzureRM provider under 2.0

# v2.0.0 - 2020-03-25

Breaking
  * AZ-94: Terraform 0.12 / HCL2 format

Added
  * AZ-118: Add LICENSE, NOTICE & Github badges

Updated
  * AZ-45: Revamp module

Changed
  * AZ-45: Use `for_each` instead of `count` on resources

# v1.0.0 - 2019-10-18

Updated
  * AZ-45: Backport upstream fork to local module

# v0.1.1 - 2019-04-30

Fixed
  * AZ-45: Use Claranet fork

# v0.1.0 - 2019-03-29

Added
  * AZ-45: First Release
