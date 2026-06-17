output "public_ip" {
  value = aws_instance.first_instance.public_ip
}

output "public_id" {
  value = aws_instance.first_instance.id
}