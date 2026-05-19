# 🟢 Ejercicio 3: Consultando la Infraestructura Existente

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Problema:** "No sabemos qué AMI usar. Necesitamos la AMI más reciente de Amazon Linux 2, pero no queremos hardcodear el ID porque cambia con las actualizaciones."

## 🎯 Objetivo

Usar Data Sources para obtener información dinámica de AWS en lugar de hardcodear valores.

## 📋 Tu tarea

### Parte 1: Buscar AMI automáticamente

Usa `data "aws_ami" "amazon_linux"` para encontrar la AMI más reciente:

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

### Parte 2: Obtener región actual

```hcl
data "aws_region" "current" {
  name = var.aws_region  # optional, defaults to current
}
```

### Parte 3: Listar Availability Zones

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

### Parte 4: Usar los datos

Crea la instancia usando los datos obtenidos:

```hcl
resource "aws_instance" "app" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  # ... rest of config
}
```

### Parte 5: Mostrar información útil

```hcl
output "ami_info" {
  description = "Información de la AMI seleccionada"
  value = {
    id       = data.aws_ami.amazon_linux.id
    name     = data.aws_ami.amazon_linux.name
    owner    = data.aws_ami.amazon_linux.owner_id
  }
}

output "available_azs" {
  description = "Zonas de disponibilidad"
  value       = data.aws_availability_zones.available.names
}
```

## 🎨 Archivos esperados

```
03-data-sources/
├── main.tf          # Data sources + resource
├── variables.tf
├── outputs.tf
└── versions.tf
```

## ✅ Criterios de aceptación

- [ ] Data source de AMI encuentra la más reciente
- [ ] Filtros son específicos para evitar AMI incorrectas
- [ ] Outputs muestran información relevante
- [ ] No hay hardcoded AMI IDs
- [ ] El código es idempotente (puede correrse múltiples veces)

## 🧪 Con Floci

Floci soporta los data sources básicos:

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}
```

**Nota:** En Floci, los data sources devuelven valores mock/emuados. Para producción, vas a obtener datos reales de AWS.

## 💡 Conceptos a aprender

- Diferencia `resource` vs `data`
- Data sources son de solo lectura
- Filtering avanzado
- Atributos: `.id`, `.name`, `.owner_id`, `.names`
- Dependencias implícitas

## 🔗 Recursos

- [aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)
- [aws_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)
- [aws_availability_zones](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones)

## ⏱️ Tiempo estimado

30-45 minutos

## 💼 Bonus: Escenario real

El equipo de seguridad quiere que solo uses AMIs que:
1. Sean de AWS (no community)
2. Tengan el tag `support_level = "standard"`
3. Sean de los últimos 90 días

Agrega estos filtros al data source.