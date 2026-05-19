# Información de la AMI usada
output "ami_info" {
  description = "Información de la AMI seleccionada"
  value = {
    id          = data.aws_ami.amazon_linux.id
    name        = data.aws_ami.amazon_linux.name
    description = data.aws_ami.amazon_linux.description
    owner       = data.aws_ami.amazon_linux.owner_id
  }
}

# Región actual
output "current_region" {
  description = "Región actual"
  value       = data.aws_region.current.name
}

# Availability Zones disponibles
output "available_azs" {
  description = "Zonas de disponibilidad"
  value       = data.aws_availability_zones.available.names
}

# ID de la instancia creada
output "instance_id" {
  description = "ID de la instancia"
  value       = aws_instance.app.id
}