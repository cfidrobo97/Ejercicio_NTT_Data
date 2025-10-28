# Variables necesarias para el despliegue en Azure
variable "resource_group_name" {
  description = "Nombre del grupo de recursos en Azure"
  type        = string
  default     = "devops-service-rg"
}

variable "location" {
  description = "Región de Azure (por ejemplo: eastus, westeurope)"
  type        = string
  default     = "eastus"
}

variable "app_service_name" {
  description = "Nombre de la App Service en Azure"
  type        = string
  default     = "devops-service-app"
}

variable "app_service_plan_name" {
  description = "Nombre del plan de App Service"
  type        = string
  default     = "devops-service-plan"
}

variable "instance_count" {
  description = "Número de instancias para el balanceo de carga"
  type        = number
  default     = 2
}

variable "docker_image" {
  description = "URL de la imagen Docker en GHCR o ACR"
  type        = string
}

# Nota: Las credenciales de Azure se manejan mediante:
# 1. Azure CLI login en GitHub Actions (azure/login@v1)
# 2. El provider de Terraform detecta automáticamente las credenciales de Azure CLI

