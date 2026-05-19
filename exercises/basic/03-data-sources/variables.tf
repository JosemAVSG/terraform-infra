# AWS Region
variable "aws_region" {
  description = "Región de AWS"
  type        = string
  default     = "us-east-1"
}

# Instance Type
variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
  default     = "t2.micro"
}

# Environment
variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "dev"
}