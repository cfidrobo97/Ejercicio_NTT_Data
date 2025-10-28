output "app_service_url" {
  description = "URL de la App"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "app_service_name" {
  value = azurerm_linux_web_app.main.name
}

output "resource_group_name" {
  value = data.azurerm_resource_group.main.name
}

output "app_service_id" {
  value = azurerm_linux_web_app.main.id
}
