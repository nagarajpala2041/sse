terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.56"  # match the lock file
    }
  }
}

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "fe8fe9a0-e971-4ed5-9bf3-55a345c13a8a"
  tenant_id       = "6a8d9eec-1f9e-43dc-abb9-020784059a92"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "flask-app-rg"
  location = "East US"
}

# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "flaskappacr12345"  # must be globally unique
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Optional: random suffix for DNS
resource "random_id" "suffix" {
  byte_length = 4
}

# Azure Container Instance
resource "azurerm_container_group" "aci" {
  name                = "flask-app-aci"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  ip_address_type     = "Public"
  dns_name_label      = "flaskapp-${random_id.suffix.hex}"

  container {
    name   = "flask-app"
    image  = "${azurerm_container_registry.acr.login_server}/health-app:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }
  }

  # Credentials to pull from ACR
  image_registry_credential {
    server   = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }
}
