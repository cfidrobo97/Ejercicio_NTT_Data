# Autenticación se configura mediante las variables en runtime
# o mediante variables de entorno AZURE_*

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

# Crear App Service (esto es tu aplicación desplegada)
resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  # Configuración de Docker
  site_config {
    application_stack {
      docker_image     = var.docker_image
      docker_image_tag = "latest"
    }
    
    # Habilitar logs
    always_on = true
    
    # Número de instancias
    worker_count = var.instance_count
  }

  # Variables de entorno
  app_settings = {
    "PORT" = "8080"
  }

  tags = {
    environment = "production"
  }
}

# Nota: La autenticación de Azure se configurará mediante:
# 1. Variables de entorno en el pipeline de GitHub Actions
# 2. Variables pasadas a terraform en runtime

