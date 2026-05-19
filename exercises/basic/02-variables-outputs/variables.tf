# Environment: dev, staging, o prod
variable "environment" {
  description = "Ambiente de despliegue (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev, staging, o prod."
  }
}

# Instance Type
variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

# Instance Name
variable "instance_name" {
  description = "Nombre de la instancia"
  type        = string
  default     = "app-server"
}

# AWS Region
variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

# Owner Team
variable "owner_team" {
  description = "Equipo responsable"
  type        = string
  default     = "engineering"
}