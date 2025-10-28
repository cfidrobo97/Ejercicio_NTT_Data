
# Crear Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "production"
    managed-by  = "terraform"
  }
}

# Crear App Service Plan (B1 con 2 instancias)
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1" 
  
  tags = {
    environment = "production"
  }
}

# Crear App Service (esto es tu aplicación desplegada)
resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  # Configuración del sitio
  site_config {
    always_on = true
    worker_count = 1
  }

  # Variables de entorno - Azure detectará Docker automáticamente
  app_settings = {
    "PORT"                                = "8080"
    "DOCKER_REGISTRY_SERVER_URL"         = "https://ghcr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"    = "cfidrobo97"
    "DOCKER_REGISTRY_SERVER_PASSWORD"    = var.ghcr_token
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_CUSTOM_IMAGE_NAME"           = var.docker_image
  }

  tags = {
    environment = "production"
  }
}
