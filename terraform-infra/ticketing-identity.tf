# Configure the Azure provider
resource "azurerm_user_assigned_identity" "identity" {
  name                = var.identity_nm
  resource_group_name = var.resource_group_name
  location            = var.location
  depends_on          = [azurerm_resource_group.rg]
}