output "terraform_module" {
  description = "Information about this Terraform module"
  value = {
    name       = "db-postgresql"
    version    = file("${path.module}/VERSION")
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
