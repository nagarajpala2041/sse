provider "azurerm" {
  features {}
  subscription_id = "fe8fe9a0-e971-4ed5-9bf3-55a345c13a8a"
  tenant_id       = "6a8d9eec-1f9e-43dc-abb9-020784059a92"
}

#  Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#  Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

#  Azure Container Instance (ACI)
resource "azurerm_container_group" "aci" {
  name                = "health-aci"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"

  container {
    name   = "health-app"
    image  = "${azurerm_container_registry.acr.login_server}/health-app:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }
  }

  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  ip_address_type = "Public"

  tags = {
    environment = "dev"
  }
}
