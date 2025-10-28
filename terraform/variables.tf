variable "resource_group_name" {
  type        = string
  default     = "devops-service-rg"
  description = "Nombre del RG existente"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Región del RG (para crearlo con az si no existe)"
}

variable "app_service_name" {
  type        = string
  default     = "devops-service-app"
}

variable "app_service_plan_name" {
  type        = string
  default     = "devops-service-plan"
}

variable "ghcr_token" {
  type        = string
  sensitive   = true
  description = "PAT de GHCR con read:packages"
}

variable "docker_image" {
  type        = string
  description = "Imagen Docker (p.ej.: ghcr.io/owner/repo:latest)"
}

variable "app_location" {
  type        = string
  default     = "eastus2" 
  description = "Región para el App Service Plan/Web App"
}
