variable "aws_region" {
  description = "La región de AWS (simulada por LocalStack)"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
  default     = "t2.micro"
}
