# 🔵 Ejercicio 7: Workspaces y Multi-Environment

## Objetivo
Gestionar múltiples entornos (dev, staging, prod) con la misma configuración.

## Estructura propuesta
```
07-workspaces/
├── main.tf              # Recursos con interpolación de workspace
├── variables.tf
├── environments/
│   ├── dev/
│   │   └── terraform.tfvars
│   ├── staging/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
```

## Tarea

### Parte 1: Workspace-aware resources
1. Usa `terraform.workspace` para:
   - Nombrar recursos con el workspace
   - Diferenciar tamaño de instancias por entorno
   - Seleccionar subnets diferentes

2. Ejemplo de mapping:
   ```hcl
   instance_type = terraform.workspace == "prod" ? "t3.large" : "t2.micro"
   ```

### Parte 2: Environments directory
1. Crea tfvars para dev, staging, prod
2. Cada uno con diferentes:
   - Instance types
   - Instance counts
   - Tags de ambiente

### Parte 3: Workspace isolation
1. Usa workspaces separados para infraestructura común (VPC)
2. Comparte outputs entre workspaces con remote state

## Conceptos clave
- Default workspace
- Workspace vs directorios separados
- Pros/Cons de cada approach
- Output extraction de otros workspaces

## Reto avanzado
Crea un setup donde:
- VPC sea común (prod workspace)
- Instancias específicas por workspace
- Outputs compartidos via remote state