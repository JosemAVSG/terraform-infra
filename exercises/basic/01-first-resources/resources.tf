# 1. Genera la llave criptográfica en memoria
# resource "tls_private_key" "rsa_key" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "dev_key" {
#   key_name   = "dev-key"
#   public_key = tls_private_key.rsa_key.public_key_openssh # Toma la parte pública automáticamente
# }

# //this is need it for security group use default vpc 
# data "aws_vpc" "default" {
#   default = true
# }

# resource "aws_security_group" "dev_groups" {
#   name        = "dev-web-sg"
#   description = "Grupo de seguridad para el entorno de desarrollo"
#   vpc_id      = data.aws_vpc.default.id

#   ingress {
#     description = "Permitir SSH seguro"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["190.108.77.190/32"] # Reemplaza con tu IP o CIDR corporativo
#   }

#   # Reglas de Salida (Egress) - Tráfico saliente
#   egress {
#     description = "Permitir toda la salida"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" # "-1" significa todos los protocolos
#     cidr_blocks = ["0.0.0.0/0"]
#   }

# }


resource "aws_instance" "first_instance" {

  ami = "ami-amazonlinux2023" // this ami is from floci catalog
  # ami           = "ami-0abcdef1234567890" // this ami is from floci catalog
  instance_type = "t2.micro"
  # key_name      = aws_key_pair.dev_key.key_name
  # security_groups = [aws_security_group.dev_groups.name]
  # vpc_security_group_ids = [aws_security_group.dev_groups.id]

  # tags = {
  #   Environment = "development"
  #   Department  = "engineering"
  #   Project     = "techstart-web"
  #   ManagedBy   = "terraform"
  # }


}
