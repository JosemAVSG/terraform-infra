# 🟢 Ejercicio 2: Configuración Flexible para Múltiples Entornos

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Situación:** El equipo de infraestructura necesita que el servidor de desarrollo pueda reconfigurarse sin cambiar el código. Además, necesitan obtener la IP para dar acceso a los desarrolladores.

## 🎯 Objetivo

Hacer el código reutilizable usando variables y exponer información necesaria via outputs.

## 📋 Tu tarea

### Parte 1: Variables de configuración

Crea variables para:

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `environment` | string | "dev" | dev, staging, prod |
| `instance_type` | string | "t2.micro" | Tamaño de instancia |
| `instance_name` | string | "app-server" | Nombre del servidor |
| `aws_region` | string | "us-east-1" | Región |
| `owner_team` | string | "engineering" | Equipo responsable |

### Parte 2: Validación

Agrega validación a `environment`:
```hcl
validation {
  condition     = contains(["dev", "staging", "prod"], var.environment)
  error_message = "Environment must be dev, staging, or prod."
}
```

### Parte 3: Tags dinámicos

Usa las variables para crear tags:
```hcl
tags = {
  Name        = var.instance_name
  Environment = var.environment
  OwnerTeam   = var.owner_team
  ManagedBy   = "terraform"
}
```

### Parte 4: Outputs necesarios

```hcl
output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "IP pública para acceso SSH"
  value       = aws_instance.app.public_ip
}

output "availability_zone" {
  description = "Zona de disponibilidad"
  value       = aws_instance.app.availability_zone
}
```

### Parte 5: Archivos tfvars

Crea `dev.tfvars`:
```hcl
environment   = "dev"
instance_type = "t2.micro"
instance_name = "techstart-dev"
```

Crea `prod.tfvars`:
```hcl
environment   = "prod"
instance_type = "t3.large"
instance_name = "techstart-prod"
```

## 🎨 Archivos esperados

```
02-variables-outputs/
├── main.tf
├── variables.tf      # Declaraciones con validación
├── outputs.tf        # 3+ outputs
├── dev.tfvars        # Config dev
├── prod.tfvars       # Config prod
└── versions.tf
```

## ✅ Criterios de aceptación

- [ ] Todas las variables tienen descripción y defaults sensatos
- [ ] Validación de environment funciona
- [ ] Tags usan todas las variables
- [ ] Outputs son claros y tienen description
- [ ] `terraform plan -var-file="dev.tfvars"` aplica configuración dev
- [ ] `terraform plan -var-file="prod.tfvars"` aplica configuración prod

## 💡 Conceptos a aprender

- Tipos de variables (string, number, bool, list, map)
- Variable validation
- Referencia: `var.nombre`
- Description y sensitive
- Archivos .tfvars
- Interpolación en strings

## 🔗 Recursos

- [Variables](https://www.terraform.io/docs/language/values/variables.html)
- [Outputs](https://www.terraform.io/docs/language/values/outputs.html)

## ⏱️ Tiempo estimado

45-60 minutos