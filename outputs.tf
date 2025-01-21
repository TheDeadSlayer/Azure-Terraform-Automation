# Host name or FQDN for your Azure PostgreSQL server
output "db_host" {
  value = azurerm_postgresql_flexible_server.db.fqdn
}

# Full username, e.g., "postgres@servername"
output "db_user" {
  value = "${azurerm_postgresql_flexible_server.db.administrator_login}@${azurerm_postgresql_flexible_server.db.name}"
  sensitive = true
}

# Password for the PostgreSQL admin user
output "db_password" {
  value     = var.db_admin_password
  sensitive = true
}

# Name of the DB if needed
output "db_name" {
  value = var.db_name
}

output "backend_app_url" {
  description = "The URL of the backend app"
  value       = "https://${azurerm_app_service.app.default_site_hostname}/api"
}