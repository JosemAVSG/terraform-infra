# Output: ID de la instancia
output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.app.id
}

# Output: IP pública
output "public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.app.public_ip
}

# Output: Estado de la instancia
output "instance_state" {
  description = "Estado de la instancia"
  value       = aws_instance.app.instance_state
}

# Output: Zona de disponibilidad
output "availability_zone" {
  description = "Zona de disponibilidad"
  value       = aws_instance.app.availability_zone
}