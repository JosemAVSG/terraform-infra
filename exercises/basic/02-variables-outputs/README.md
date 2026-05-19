# 🟢 Ejercicio 2: Variables y Outputs

## Objetivo
Dominar el uso de variables de entrada y salida para hacer el código reutilizable.

## Tarea
1. Crea variables para:
   - `instance_type` (default: "t2.micro")
   - `instance_name` (default: "demo-instance")
   - `aws_region` (default: "us-east-1")

2. Crea outputs que muestren:
   - ID de la instancia
   - IP pública
   - Zona de disponibilidad

3. Usa un archivo `terraform.tfvars` para sobrescribir los defaults

## Archivos esperados
- `main.tf` - Provider y recurso
- `variables.tf` - Declaraciones de variables
- `outputs.tf` - Definición de outputs
- `terraform.tfvars` - Valores personalizados

## Conceptos clave
- Tipos de variables: string, number, bool, list, map
- Variable validation
- Referencia con `var.nombre`
- Output sensitive/description

## Verificación
```bash
terraform output  # Ver los outputs después de apply
```