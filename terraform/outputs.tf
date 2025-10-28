# URLs de salida después del despliegue
output "app_service_url" {
  description = "URL del servicio desplegado en Azure"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "app_service_name" {
  description = "Nombre de la App Service"
  value       = azurerm_linux_web_app.main.name
}

output "resource_group_name" {
  description = "Nombre del grupo de recursos"
  value       = azurerm_resource_group.main.name
}

output "app_service_id" {
  description = "ID de la App Service"
  value       = azurerm_linux_web_app.main.id
}



