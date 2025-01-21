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

#################################
# 1) Resource Group
#################################
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#################################
# 2) Azure PostgreSQL Flexible Server
#################################
resource "azurerm_postgresql_flexible_server" "db" {
  name                = var.db_server_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  administrator_login = var.db_admin_username
  administrator_password = var.db_admin_password
  version             = "14"
  sku_name            = "B_Standard_B1ms" # Or "Standard_B1ms" if needed
  storage_mb          = 32768
 # Ensure public access is enabled
  public_network_access_enabled = true
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name     = "allow_all_ips"
  server_id = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# The actual "employeesdb" (or whatever db_name) on that server
resource "azurerm_postgresql_flexible_server_database" "employees" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.db.id
  collation = "en_US.utf8"
  charset   = "UTF8"

  # Ensure the DB waits for the server to finish provisioning
  depends_on = [azurerm_postgresql_flexible_server.db]
}

#################################
# (New) Initialize a table with (id, name, role)
#################################
resource "null_resource" "init_employees_table" {
  depends_on = [
    azurerm_postgresql_flexible_server_database.employees,
    azurerm_postgresql_flexible_server_firewall_rule.allow_all
  ]

  provisioner "local-exec" {
    environment = {
      PGPASSWORD = var.db_admin_password
    }

    command = <<EOT
      psql \
        --host=${azurerm_postgresql_flexible_server.db.fqdn} \
        --port=5432 \
        --username=${var.db_admin_username}@${var.db_server_name} \
        --dbname=${var.db_name} \
        --set=sslmode=require \
        -c "CREATE TABLE IF NOT EXISTS employees (
             id SERIAL PRIMARY KEY,
             name TEXT NOT NULL,
             role TEXT NOT NULL
           );"
    EOT
  }
}

#################################
# 3) Azure Container Registry (optional)
#################################
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

#################################
# 4) App Service Plan (Use azurerm_service_plan, not azurerm_app_service_plan)
#################################
resource "azurerm_service_plan" "asp" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  # Required in the newer azurerm provider
  os_type   = "Linux"  # or "Windows"

  # e.g. Basic B1, Premium P1v2, etc.
  sku_name = "B1"
}

#################################
# Random suffix for a globally-unique App Service name
#################################
resource "random_string" "suffix" {
  length  = 6
  special = false
}

#################################
# Azure App Service (Container)
#################################
resource "azurerm_app_service" "app" {
  # Must be globally unique
  name                = "${var.app_name}-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  app_service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/${var.image_name}:latest"
  }

  # Pass DB connection info as environment variables
  app_settings = {
    DB_HOST       = azurerm_postgresql_flexible_server.db.fqdn
    DB_PORT       = "5432"
    DB_USER       = "${var.db_admin_username}@${var.db_server_name}"
    DB_PASSWORD   = var.db_admin_password
    DB_NAME       = var.db_name
    WEBSITES_PORT = "4000"
  }
}
