variable "resource_group_name" {
  type        = string
  default     = "devops-service-rg"
  description = "RG existente"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Región del RG (solo informativo)"
}

variable "docker_image" {
  type        = string
  description = "Imagen Docker (ej: ghcr.io/owner/repo:latest)"
}

variable "ghcr_username" {
  type        = string
  description = "Usuario de GitHub para GHCR (ej: cfidrobo97)"
}

variable "ghcr_token" {
  type        = string
  sensitive   = true
  description = "PAT GHCR con read:packages"
}

variable "container_port" {
  type        = number
  default     = 8080
}

variable "container_cpu" {
  type        = number
  default     = 1
}

variable "container_memory" {
  type        = number
  default     = 1.5
}
