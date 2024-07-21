resource "azurerm_container_app_environment" "aca_environment" {
  name                = var.aca_environment
  location            = var.location
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_resource_group.rg, azurerm_user_assigned_identity.identity]
}