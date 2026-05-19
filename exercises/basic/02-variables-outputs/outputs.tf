# ID de la instancia
output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.app.id
}

# IP pública
output "public_ip" {
  description = "IP pública para acceso SSH"
  value       = aws_instance.app.public_ip
}

# Zona de disponibilidad
output "availability_zone" {
  description = "Zona de disponibilidad"
  value       = aws_instance.app.availability_zone
}

# Tags aplicados
output "applied_tags" {
  description = "Tags aplicados a la instancia"
  value       = aws_instance.app.tags
}