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

resource "azurerm_container_group" "main" {
  name                = "devops-service-aci"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  os_type             = "Linux"

  ip_address_type     = "Public"
  dns_name_label      = "devops-service-${random_string.suffix.result}" # subdominio público
  restart_policy      = "Always"

  container {
    name   = "app"
    image  = var.docker_image                       # ghcr.io/owner/repo:tag
    cpu    = var.container_cpu
    memory = var.container_memory

    ports {
      port     = var.container_port                 # expone tu puerto (8080 por defecto)
      protocol = "TCP"
    }

    environment_variables = {
      PORT = tostring(var.container_port)
    }
  }

  # Credenciales para imagen privada en GHCR
  image_registry_credential {
    server   = "ghcr.io"
    username = var.ghcr_username                    # p.ej. "cfidrobo97"
    password = var.ghcr_token                       # PAT con read:packages
  }

  tags = { environment = "production" }
}

output "app_url" {
  description = "URL pública del contenedor"
  value       = "http://${azurerm_container_group.main.fqdn}:${var.container_port}"
}