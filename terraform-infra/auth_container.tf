resource "azurerm_container_app" "aca_app_auth" {
  name                         = var.app_auth
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  depends_on = [azurerm_container_app_environment.aca_environment , azurerm_key_vault.vault]

  template {
    container {
      name   = var.app_auth
      image  = "docker.io/vmittal26/auth:v1"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name = var.db_secret_name
        secret_name = var.db_secret_name
        value = "secretref:mongo-db-conn-str"
      }

      env {
        name = var.service_port_name
        value = var.service_port
      }
    }
  }

  secret {
    name = var.db_secret_name
    identity = azurerm_user_assigned_identity.identity.id
    key_vault_secret_id = azurerm_key_vault_secret.secret.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.identity.id]
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = var.service_port
    transport                  = "auto"

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  lifecycle {
    ignore_changes = [secret]
  }
}

output "app_auth_url" {
  value = azurerm_container_app.aca_app_auth.latest_revision_fqdn
}


# resource "terraform_data" "add_secrets" {
#   count            = 1
#   triggers_replace = []

#   lifecycle {
#     replace_triggered_by = [azurerm_container_app.aca_auth_app]
#   }

#   provisioner "local-exec" {

#     # interpreter = [ "bash", "-c" ]
#     interpreter = ["PowerShell", "-Command"]

#     command = <<-EOT
    
#         az containerapp secret set `
#           --name ${azurerm_container_app.aca_auth_app.name} `
#           --resource-group ${azurerm_resource_group.rg.name} `
#           --secrets mongo-db-conn-str=keyvaultref:https://ticketing-app-key-vault.vault.azure.net/secrets/mongo-db-conn-str,identityref:${azurerm_user_assigned_identity.identity.id}

#           az containerapp update `
#           --name ${azurerm_container_app.aca_auth_app.name} `
#           --resource-group ${azurerm_resource_group.rg.name} `
#           --set-env-vars "mongo-db-conn-str=secretref:mongo-db-conn-str"
         
#       EOT
#     when    = create
#   }

#   depends_on = [azurerm_container_app.aca_auth_app,azurerm_key_vault.vault]
# }