# 🟢 Ejercicio 3: Data Sources

## Objetivo
Aprender a usar Data Sources para obtener información existente en lugar de crear recursos desde cero.

## Tarea
1. Usa `data "aws_ami" "amazon_linux"` para encontrar:
   - AMI más reciente de Amazon Linux 2
   - Filtrar por owner: "amazon"
   - Filtrar por nombre que contenga "amzn2-ami-hvm-*-x86_64-gp2"

2. Usa `data "aws_region" "current"` para obtener la región actual

3. Usa `data "aws_availability_zones" "available"` para listar AZs disponibles

4. Crea una instancia usando los datos obtenidos

## Archivos esperados
- `main.tf` - Data sources y recurso

## Conceptos clave
- Diferencia entre resource y data source
- Filtrado con filtros y nombre
- Atributos: `.id`, `.name`, `.names`, etc.
- Data source de Terraform

## Reto extra
Usa el output para mostrar el nombre de la AMI y las AZs disponibles