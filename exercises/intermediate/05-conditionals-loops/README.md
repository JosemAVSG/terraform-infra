# 🟡 Ejercicio 5: Infraestructura Dinámica

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Situación:** 
- "En producción necesitamos IP pública, en dev no"
- "Necesitamos crear múltiples buckets S3 para diferentes equipos"
- "Queremos configurar diferentes reglas de seguridad según el ambiente"

## 🎯 Objetivo

Dominar la creación dinámica de recursos usando expresiones de Terraform.

## 📋 Tu tarea

### Parte 1: Condicionales

**Escenario:** Crear o no recursos según configuración

```hcl
variable "enable_public_ip" {
  description = "Si true, asigna IP pública a la instancia"
  type        = bool
  default     = false
}

variable "environment" {
  description = "dev, staging, o prod"
  type        = string
  default     = "dev"
}
```

Usar conditional para:
1. Asignar IP pública solo si `enable_public_ip = true`
2. Crear EIP solo en producción
3. Configurar diferentes sizes según environment

```hcl
# IP pública condicional
resource "aws_instance" "app" {
  # ... other config
  
  associate_public_ip_address = var.enable_public_ip
}

# EIP condicional
resource "aws_eip" "prod_ip" {
  count = var.environment == "prod" ? 1 : 0
  
  instance = aws_instance.app.id
}
```

### Parte 2: for_each - Múltiples recursos

**Escenario:** Crear múltiples buckets S3 con configuración variable

```hcl
variable "buckets" {
  description = "Mapa de configuración de buckets"
  type = map(object({
    versioning  = bool
    lifecycle_rule = bool
    tags        = map(string)
  }))

  default = {
    "techstart-assets" = {
      versioning  = true
      lifecycle_rule = true
      tags = { team = "frontend" }
    }
    "techstart-logs" = {
      versioning  = true
      lifecycle_rule = true
      tags = { team = "devops" }
    }
    "techstart-backups" = {
      versioning  = false
      lifecycle_rule = false
      tags = { team = "dba" }
    }
  }
}
```

Crear los buckets:

```hcl
resource "aws_s3_bucket" "app" {
  for_each = var.buckets

  bucket = each.key

  tags = each.value.tags
}

resource "aws_s3_bucket_versioning" "app" {
  for_each = { for k, v in var.buckets : k => v if v.versioning }
  
  bucket = each.key
  
  versioning_configuration {
    status = "Enabled"
  }
}
```

### Parte 3: for - Transformaciones

**Escenario:** Generar tags desde una lista

```hcl
variable "tags_list" {
  type    = list(string)
  default = ["env", "team", "project"]
}

# Crear map de tags
locals {
  tags = { for tag in var.tags_list : tag => var.environment }
  # Result: { "env" = "prod", "team" = "prod", "project" = "prod" }
}
```

**Escenario:** Filtrar y transformar

```hcl
variable "instances" {
  type = list(object({
    name = string
    type = string
    env  = string
  }))

  default = [
    { name = "web-1", type = "t3.small", env = "prod" },
    { name = "web-2", type = "t3.small", env = "prod" },
    { name = "dev-1", type = "t2.micro", env = "dev" },
  ]
}

# Solo instancias de prod
locals {
  prod_instances = [for i in var.instances : i if i.env == "prod"]
}
```

### Parte 4: Funciones útiles

```hcl
# lookup - valores por defecto
locals {
  default_type = lookup(var.config, "instance_type", "t3.micro")
}

# coalesce - primer valor no nulo
locals {
  env = coalesce(var.environment, "dev", "default")
}

# merge - combinar maps
locals {
  common_tags = { ManagedBy = "terraform", Project = "techstart" }
  env_tags    = { Environment = var.environment }
  all_tags    = merge(common_tags, env_tags)
}

# length, keys, values
locals {
  bucket_count = length(var.buckets)
  bucket_names = keys(var.buckets)
}
```

## 🎨 Archivos esperados

```
05-conditionals-loops/
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md  # Documentar decisiones
```

## ✅ Criterios de aceptación

- [ ] Conditional funciona: `var.condition ? a : b`
- [ ] for_each crea múltiples recursos correctamente
- [ ] for transforma listas/maps según necesidad
- [ ] Funciones (lookup, coalesce, merge) usadas correctamente
- [ ] Código es claro y mantenible
- [ ] Documentación explica la lógica

## 🧪 Con Floci

Floci soporta S3, EC2, y la mayoría de servicios necesarios para estos ejercicios.

```hcl
# Con Floci, los recursos se crean en el emulador
resource "aws_s3_bucket" "example" {
  for_each = toset(["bucket-a", "bucket-b"])
  bucket   = each.value
}

# Crear múltiples con for_each
resource "aws_instance" "servers" {
  for_each = tomap({
    web = "t3.small"
    api = "t3.micro"
    db  = "t3.medium"
  })

  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
```

**Endpoints para Floci:**
```hcl
provider "aws" {
  endpoints {
    s3    = "http://localhost:4566"
    ec2   = "http://localhost:4566"
    # etc...
  }
}
```

## 💡 Conceptos a aprender

- `count` y `for_each` - cuándo usar cada uno
- Expresiones ternarias
- `tomap()`, `tolist()`, `toset()`
- Built-in functions
- Metaprogramming en Terraform

## 🔗 Recursos

- [Expressions](https://www.terraform.io/docs/language/expressions/index.html)
- [Functions](https://www.terraform.io/docs/language/functions/index.html)
- [Count & For Each](https://www.terraform.io/docs/language/meta-arguments/count.html)

## ⏱️ Tiempo estimado

60-90 minutos

## 💼 Reto final

Crea una configuración que:
1. Use un map de 5 instancias con diferentes configs
2. Cree un security group por instancia
3. Solo las instancias en subnets públicas tengan EIP
4. Use una función para validar que el tipo de instancia exista