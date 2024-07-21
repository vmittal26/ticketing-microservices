data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "vault" {
  name                        = var.vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  depends_on = [ azurerm_user_assigned_identity.identity ]


  access_policy {
    object_id = azurerm_user_assigned_identity.identity.principal_id
    tenant_id = azurerm_user_assigned_identity.identity.tenant_id
    secret_permissions = [
      "Get", "Set"
    ]
    storage_permissions = [
      "Get"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions = [
      "Get", "Delete"
    ]
    secret_permissions = [
      "Get", "Set", "List", "Delete", "Purge", "Recover"
    ]
    storage_permissions = [
      "Get"
    ]
  }
  
}

resource "azurerm_key_vault_secret" "secret" {
  name         = var.db_secret_name
  value        = "mongodb+srv://dbadmin:vaibhav86!@ticketing-app-db-cluster.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000"
  key_vault_id = azurerm_key_vault.vault.id
}