terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = "3fca4538-23fa-4853-94bd-604378fbbb2b"
  tenant_id       = "bf0c06c2-6aa7-4abe-9732-ce9b2b3c7264"
  client_id       = "0cb15086-3fbc-4228-8b15-0ed4a10fba62"
  client_secret   = "XqY8Q~QbKfTCgi6G9uPx2XWLDAcwGg-XpOLLHawq"
  features {

    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}