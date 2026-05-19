# 🟡 Ejercicio 6: Estado Remoto y Trabajo en Equipo

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Problema:** 
- "El archivo terraform.tfstate está en mi máquina y nadie más puede ver los recursos"
- "Dos personas applyaron al mismo tiempo y se rompió todo"
- "Necesitamos que el state persista si alguien borra su máquina"

## 🎯 Objetivo

Configurar un backend remoto para almacenar el state de forma segura y compartirlo.

## 📋 Tu tarea

### Parte 1: Backend S3 básico

**Objetivo:** Guardar el state en S3 (puede ser LocalStack)

```hcl
terraform {
  backend "s3" {
    bucket         = "techstart-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
    # Para LocalStack:
    # endpoint        = "http://localhost:4566"
    # skip_credentials_validation = true
  }
}
```

**Tareas:**
1. Crear el bucket S3 manualmente (o con Terraform)
2. Configurar el backend
3. Correr `terraform init` para migrar

### Parte 2: State Locking

**Objetivo:** Evitar que dos personas apply al mismo tiempo

```hcl
terraform {
  backend "s3" {
    bucket         = "techstart-terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
    # DynamoDB para locking
    dynamodb_table = "terraform-locks"
  }
}
```

**Tareas:**
1. Crear la tabla DynamoDB:
   ```hcl
   resource "aws_dynamodb_table" "terraform_locks" {
     name         = "terraform-locks"
     billing_mode = "PAY_PER_REQUEST"
     hash_key     = "LockID"
   
     attribute {
       name = "LockID"
       type = "S"
     }
   }
   ```

### Parte 3: State isolation con Workspaces

**Objetivo:** Mantener states separados por ambiente

```bash
# Crear workspaces
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

**En el backend:**

```hcl
terraform {
  backend "s3" {
    bucket         = "techstart-terraform-state"
    key            = "dev/${terraform.workspace}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

Ahora cada workspace tiene su propio state:
- `dev/dev/terraform.tfstate`
- `dev/staging/terraform.tfstate`
- `dev/prod/terraform.tfstate`

### Parte 4: State remoto y referencia

**Escenario:** La VPC de producción es compartida, las instancias son por workspace

```hcl
# En el workspace "prod", crear la VPC una vez
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name        = "prod-vpc"
    Environment = "prod"
  }
}

output "vpc_id" {
  value = aws_vpc.main.id
}

# En otro proyecto o workspace, referenciar
data "terraform_remote_state" "vpc" {
  backend = "s3"
  
  config = {
    bucket = "techstart-terraform-state"
    key    = "dev/prod/terraform.tfstate"
  }
}

# Usar el output
resource "aws_instance" "app" {
  # ...
  subnet_id = data.terraform_remote_state.vpc.outputs.vpc_id
}
```

## 🎨 Archivos esperados

```
06-remote-state/
├── main.tf              # Recursos + backend
├── backend.tf           # Backend config (separado)
├── dynamodb.tf          # Tabla de locks
├── variables.tf
├── versions.tf
└── README.md  # Explicar setup
```

## ✅ Criterios de aceptación

- [ ] Backend S3 configurado y funcionando
- [ ] State se almacena en S3 (verificar archivo)
- [ ] Locking funciona (probar con dos terminals)
- [ ] Workspaces crean states separados
- [ ] Remote state reference funciona
- [ ] Documentación explica la arquitectura

## 🧪 Con LocalStack

```hcl
# Configuración para LocalStack
terraform {
  backend "s3" {
    bucket         = "terraform-state"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    
    # LocalStack specifics
    endpoint        = "http://localhost:4566"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    s3_use_path_style          = true
  }
}
```

```bash
# Crear bucket en LocalStack
aws --endpoint-url=http://localhost:4566 s3 mb s3://terraform-state

# Crear tabla DynamoDB
aws --endpoint-url=http://localhost:4566 dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

## 💡 Conceptos a aprender

- Diferencia local vs remote state
- State locking y why it matters
- Workspaces vs directorios separados
- State encryption (S3)
- Remote state data source
- `terraform state` CLI

## 🔗 Recursos

- [Backend](https://www.terraform.io/docs/language/settings/backends/index.html)
- [S3 Backend](https://www.terraform.io/docs/language/settings/backends/s3.html)
- [Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)

## ⏱️ Tiempo estimado

60-90 minutos

## ⚠️ Notas importantes

1. **Nunca guardar secrets en state** - el state puede estar en texto plano en S3
2. **Habilitar encryption** en S3 (`encrypt = true`)
3. **Activar versioning** en el bucket S3 para recuperar estados anteriores
4. **Access controls** - limitar quién puede leer/escribir el state

## 💼 Reto: Pipeline CI/CD

Investigar cómo configurar el backend en un pipeline de GitHub Actions o GitLab CI donde las credenciales vienen de secrets.