terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}

# 1) Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 2) Azure PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "db" {
  name                = var.db_server_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  administrator_login = var.db_admin_username
  administrator_password = var.db_admin_password
  version             = "14"
  sku_name            = "Standard_B1ms"
  storage_mb          = 32768
  # For demonstration - not production config
}

# Database for employees
resource "azurerm_postgresql_flexible_server_database" "employees" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_postgresql_flexible_server.db.name
  collation           = "en_US.utf8"
  charset             = "UTF8"
}

# 3) (Optional) Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# 4) Azure App Service Plan + Web App for Container
# Alternatively, you could use Azure Container Instances or AKS
resource "azurerm_app_service_plan" "asp" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku {
    tier = "BASIC"
    size = "B1"
  }
}

resource "azurerm_app_service" "app" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.asp.id

  # Settings: either point to ACR or Docker Hub image (once built)
  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.image_name}:latest"
  }

  # Pass environment variables for DB config
  app_settings = {
    DB_HOST     = azurerm_postgresql_flexible_server.db.fqdn
    DB_PORT     = "5432"
    DB_USER     = "${var.db_admin_username}@${var.db_server_name}"
    DB_PASSWORD = var.db_admin_password
    DB_NAME     = var.db_name
    WEBSITES_PORT = "4000"  # if needed
  }
}
