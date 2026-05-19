# 🟡 Ejercicio 6: Remote State y Backend

## Objetivo
Configurar un backend remoto para almacenar el state y compartirlo entre equipos.

## Tarea

### Parte 1: LocalStack S3 Backend (simulado)
1. Configura el backend para usar S3 (puede ser LocalStack):
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "terraform-state"
       key            = "dev/terraform.tfstate"
       region         = "us-east-1"
       endpoint       = "http://localhost:4566"
       skip_credentials_validation = true
       skip_metadata_api_check     = true
       skip_requesting_account_id  = true
       s3_use_path_style          = true
     }
   }
   ```

### Parte 2: State locking
1. Agrega DynamoDB para locking:
   ```hcl
   dynamodb_table = "terraform-locks"
   ```

### Parte 3: State splitting (workspace-based)
1. Usa workspaces para diferentes entornos:
   ```bash
   terraform workspace new dev
   terraform workspace new prod
   ```

## Conceptos clave
- Diferencia entre local y remote state
- State locking
- State isolation con workspaces
- Backend block (no dentro de resource)
- `terraform state` commands

## Comandos útiles
```bash
terraform state list          # Ver recursos
terraform state show RESOURCE # Ver detalles
terraform state mv A B       # Mover recurso
terraform workspace show     # Ver workspace actual
```

## Reto
Configura un proyecto con 2 workspaces que compartan algunos recursos (VPC común)