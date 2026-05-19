# 🟡 Ejercicio 5: Conditionals y Loops

## Objetivo
Dominar la creación dinámica de recursos usando expresiones de Terraform.

## Tarea

### Parte 1: Conditional
1. Crea una variable `enable_public_ip = true`
2. Usa un conditional para decidir si crear o no una IP elástica:
   ```hcl
   resource "aws_eip" "example" {
     count = var.enable_public_ip ? 1 : 0
   }
   ```

### Parte 2: for_each y for
1. Crea una lista de objetos para múltiples instancias:
   ```hcl
   instances = [
     { name = "web", type = "t2.micro" },
     { name = "app", type = "t3.small" },
     { name = "db",  type = "t3.medium" }
   ]
   ```
2. Usa `for_each` para crear instancias desde esa lista

### Parte 3: Expresiones for
1. Crea un map de tags desde una lista
2. Usa `lookup` para obtener valores de maps

## Archivos esperados
- `main.tf` - Recursos con expresiones
- `variables.tf` - Definiciones

## Conceptos clave
- `condition ? true_value : false_value`
- `for_each = toset()` o `for_each = tomap()`
- `for key, value in list : key => value`
- `length()`, `keys()`, `values()`

## Reto
Crear 3 buckets S3 con diferentes configuraciones basado en un map de configuración