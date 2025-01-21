output "db_host" {
  description = "Database host"
  value       = azurerm_postgresql_flexible_server.db.fqdn
}

output "db_user" {
  description = "Database user"
  value       = "${var.db_admin_username}@${azurerm_postgresql_flexible_server.db.name}"
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