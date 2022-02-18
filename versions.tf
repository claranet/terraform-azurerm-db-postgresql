terraform {
  required_version = "> 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.7"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.1"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.14"
    }
  }
}
