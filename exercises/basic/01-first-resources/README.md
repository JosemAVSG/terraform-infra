# 🟢 Ejercicio 1: Tus Primeros Recursos

## Objetivo
Crear tu primer recurso en AWS (una instancia EC2) entendiendo la estructura básica de Terraform.

## Tarea
1. Define un provider AWS con la región `us-east-1`
2. Crea una instancia EC2 con:
   - AMI: `ami-0c55b159cbfafe1f0` (Amazon Linux 2)
   - Tipo: `t2.micro`
   - Tags: Name = "mi-primera-instancia"

## Archivos esperados
- `main.tf` - Provider y recurso
- `variables.tf` - Variables (opcional)

## Verificación
```bash
terraform init
terraform validate
terraform plan
```

## Aprende
- Sintaxis básica de recursos
- Provider block
- Estructura de un archivo .tf

## Referencia
[Terraform AWS Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)