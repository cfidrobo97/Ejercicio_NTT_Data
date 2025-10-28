# Crear Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "production"
    managed-by  = "terraform"
  }
}

# Crear App Service Plan (F1 con 2 instancias)
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "F1"
  
  tags = {
    environment = "production"
  }
}

# Crear App Service 
resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  # Configuración de Docker
  site_config {
    # Configurar Docker desde GHCR
    linux_fx_version = "DOCKER|${var.docker_image}"
    
    # Habilitar always on para producción
    always_on = true
    
    # Número de instancias
    worker_count = var.instance_count
  }

  # Variables de entorno y configuración de Docker Registry
  app_settings = {
    "PORT" = "8080"
    "DOCKER_REGISTRY_SERVER_URL"      = "https://ghcr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME" = "cfidrobo97"
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.ghcr_token
  }

  tags = {
    environment = "production"
  }
}
