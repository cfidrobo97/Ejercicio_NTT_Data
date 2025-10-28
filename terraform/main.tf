terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Leer el Resource Group
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# App Service Plan (Linux B1)
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "B1"
  tags = { environment = "production" }
}

# App Service (Linux) con imagen de GHCR
resource "azurerm_linux_web_app" "main" {
  name                = var.app_service_name
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    always_on    = true
    worker_count = 1
  }

  app_settings = {
    "PORT"                               = "8080"
    "DOCKER_REGISTRY_SERVER_URL"         = "https://ghcr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME"    = "cfidrobo97"
    "DOCKER_REGISTRY_SERVER_PASSWORD"    = var.ghcr_token
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"= "false"
    "DOCKER_CUSTOM_IMAGE_NAME"           = var.docker_image
  }

  tags = { environment = "production" }
}
