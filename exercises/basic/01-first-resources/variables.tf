# Variable: AWS Region
variable "aws_region" {
  description = "La región de AWS"
  type        = string
  default     = "us-east-1"
}

# Variable: Instance Type
variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}