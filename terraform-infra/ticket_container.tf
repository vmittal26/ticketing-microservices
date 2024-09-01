resource "azurerm_container_app" "aca_app_ticket" {
  name                         = var.app_ticket
  container_app_environment_id = azurerm_container_app_environment.aca_environment.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  depends_on = [azurerm_container_app_environment.aca_environment , azurerm_key_vault.vault]

  template {
    container {
      name   = var.app_ticket
      image  = "docker.io/vmittal26/tickets:v1"
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

output "app_ticket_url" {
  value = azurerm_container_app.aca_app_ticket.latest_revision_fqdn
}