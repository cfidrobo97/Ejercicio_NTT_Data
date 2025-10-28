variable "resource_group_name" {
  description = "Nombre del RG existente"
  type        = string
  default     = "devops-service-rg"
}

variable "location" {
  description = "Región de Azure (para crear RG si no existe desde az)"
  type        = string
  default     = "eastus"
}

variable "app_service_name" {
  description = "Nombre de la App Service"
  type        = string
  default     = "devops-service-app"
}

variable "app_service_plan_name" {
  description = "Nombre del App Service Plan"
  type        = string
  default     = "devops-service-plan"
}

variable "ghcr_token" {
  description = "Token de GHCR (read:packages)"
  type        = string
  sensitive   = true
}

variable "docker_image" {
  description = "Imagen Docker en GHCR o ACR (ej: ghcr.io/owner/repo:latest)"
  type        = string
}
