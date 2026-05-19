# 🔵 Ejercicio 7: Multi-Environment con Workspaces

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Situación:**
- "Necesitamos 3 ambientes: dev, staging, prod"
- "Cada ambiente tiene diferentes recursos y tamaños"
- "Queremos que el código sea el mismo, solo cambie la configuración"
- "Prod necesita más recursos, dev puede ser pequeño"

## 🎯 Objetivo

Gestionar múltiples entornos con la misma configuración de código.

## 📋 Tu tarea

### Estructura propuesta

```
07-workspaces/
├── main.tf              # Recursos con lógica por workspace
├── variables.tf
├── outputs.tf
├── environments/
│   ├── dev/
│   │   └── terraform.tfvars
│   ├── staging/
│   │   └── terraform.tfvars
│   └── prod/
│       └── terraform.tfvars
├── networking/
│   ├── main.tf         # VPC común (separada por workspace)
│   └── variables.tf
└── compute/
    ├── main.tf         # Instancias específicas por workspace
    └── variables.tf
```

### Parte 1: Configuración basada en workspace

```hcl
variable "instance_config" {
  type = map(object({
    instance_type = string
    min_size      = number
    max_size      = number
    desired_size  = number
  }))

  default = {
    dev     = { instance_type = "t3.micro",  min_size = 1, max_size = 2, desired_size = 1 }
    staging = { instance_type = "t3.small", min_size = 2, max_size = 4, desired_size = 2 }
    prod    = { instance_type = "t3.large",  min_size = 3, max_size = 10, desired_size = 5 }
  }
}

locals {
  config = var.instance_config[terraform.workspace]
}
```

### Parte 2: Recursos workspace-aware

```hcl
resource "aws_instance" "app" {
  # La configuración cambia según el workspace
  instance_type = local.config.instance_type
  # ... rest of config

  tags = {
    Name        = "app-${terraform.workspace}"
    Environment = terraform.workspace
    # Tags específicos
    team = terraform.workspace == "prod" ? "platform" : "devteam"
  }
}
```

### Parte 3: tfvars por ambiente

**dev/terraform.tfvars:**
```hcl
environment     = "dev"
instance_type   = "t3.micro"
instance_count  = 1
enable_monitoring = false
```

**staging/terraform.tfvars:**
```hcl
environment     = "staging"
instance_type   = "t3.small"
instance_count  = 2
enable_monitoring = true
```

**prod/terraform.tfvars:**
```hcl
environment     = "prod"
instance_type   = "t3.large"
instance_count  = 5
enable_monitoring = true
```

### Parte 4: VPC con workspaces

```hcl
variable "vpc_cidr" {
  type = map(string)
  default = {
    dev     = "10.0.0.0/18"     # /18 para dev
    staging = "10.0.64.0/18"    # /18 para staging
    prod    = "10.1.0.0/16"     # /16 para prod (más grande)
  }
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr[terraform.workspace]
  
  tags = {
    Name        = "vpc-${terraform.workspace}"
    Environment = terraform.workspace
  }
}
```

### Parte 5: Outputs workspace-specific

```hcl
output "current_workspace" {
  value = terraform.workspace
}

output "config_for_workspace" {
  value = local.config
}
```

## ✅ Criterios de aceptación

- [ ] Workspaces: dev, staging, prod creados
- [ ] Cada workspace tiene diferente tfvars
- [ ] La configuración de recursos cambia por workspace
- [ ] Los recursos tienen tags con el nombre del workspace
- [ ] Outputs muestran en qué workspace estás
- [ ] El código es DRY (Don't Repeat Yourself)

## 🧪 Commands

```bash
# Ver workspace actual
terraform workspace show

# Listar workspaces
terraform workspace list

# Seleccionar workspace
terraform workspace select dev

# Crear workspace
terraform workspace new prod

# Plan específico por workspace
terraform plan -var-file="environments/dev/terraform.tfvars"

# Apply específico
terraform apply -var-file="environments/prod/terraform.tfvars"
```

## 🎨 Archivos esperados

```
07-workspaces/
├── main.tf
├── variables.tf
├── outputs.tf
├── environments/
│   ├── dev/terraform.tfvars
│   ├── staging/terraform.tfvars
│   └── prod/terraform.tfvars
└── README.md  # Explicar estrategia
```

## 💡 Conceptos a aprender

- `terraform.workspace` variable
- Maps para configuración por ambiente
- Estrategia tfvars por ambiente
- Pros/contras de workspaces vs directorios
- State isolation
- Named workspaces vs default

## ⚠️ Considerations

| Approach | Ventajas | Desventajas |
|----------|----------|-------------|
| **Workspaces** | Un solo código, state separado | Complejo para proyectos grandes |
| **Directorios** | Total isolation, más claro | Duplicación de código |
| **Módulos** | Reutilización máxima | Más complejo inicialmente |

## 🔗 Recursos

- [Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)
- [Environment](https://www.terraform.io/docs/language/meta-arguments/depends_on.html)

## ⏱️ Tiempo estimado

60-90 minutos

## 💼 Reto: Shared VPC

Cómo harías para compartir la VPC de producción con los otros workspaces? (Pista: usa `terraform_remote_state`)