terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.43.0"
    }
  }
  cloud {
    organization = "myInc"

    workspaces {
      name = "terraformCI"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

variable "storage_account_replication_type" {
  type    = string
  default = "LRS"
}

locals {
  workload_name = "data10050023"
  environment   = "prod"
  instance      = "001"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.workload_name}-${local.workload_name}-${local.instance}"
  location = "East US"
}

resource "azurerm_storage_account" "myacc" {
  name                     = "st${local.workload_name}${local.workload_name}${local.instance}"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = var.storage_account_replication_type
}

output "storage_account_primaty_blob_host" {
  value = azurerm_storage_account.myacc.primary_blob_host
}
