output "rg_name" {
  description = "Resource Group"
  value       = "${var.resource_group_name}"
}

output "db_host" {
  description = "Database host"
  value       = azurerm_postgresql_flexible_server.db.fqdn
}

output "db_user" {
  description = "Database user"
  value       = "${var.db_admin_username}"
}

output "db_password" {
  description = "Database password"
  value       = var.db_admin_password
}

output "db_name" {
  description = "Database name"
  value       = azurerm_postgresql_flexible_server_database.employees.name
}

output "backend_app_url" {
  description = "The API URL for the backend"
  value       = "https://${azurerm_app_service.app.default_site_hostname}/api"
}

output "frontend_app_name" {
  description = "Frontend app name"
  value       = azurerm_app_service.frontend_app.name
}

output "backend_app_name" {
  description = "Backend app name"
  value       = azurerm_app_service.app.name
}

output "acr_login_server"{
  description = "ACR Login Server"
  value =  azurerm_container_registry.acr.login_server
}

output "acr_password" {
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
  description = "The admin password for the Azure Container Registry"
}