# 🟡 Ejercicio 4: Módulos Reutilizables para el Equipo

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Situación:** El equipo de infraestructura nota que están creando la misma instancia EC2 una y otra vez para diferentes servicios (web, api, workers). Quieren estandarizar y poder reutilizar el código.

## 🎯 Objetivo

Crear un módulo reutilizable que el equipo pueda usar para cualquier servicio.

## 📋 Tu tarea

### Estructura requerida

```
04-modules/
├── main.tf              # Uso del módulo
├── variables.tf         # Variables del root module
├── environments/
│   └── production/
│       └── main.tf      # Ejemplo de uso en prod
└── modules/
    └── ec2-service/
        ├── main.tf      # Código del módulo
        ├── variables.tf # Inputs del módulo
        └── outputs.tf  # Outputs del módulo
```

### Parte 1: Crear el módulo `ec2-service`

El módulo debe aceptar:
- `service_name` (required): nombre del servicio
- `instance_type` (default: "t3.micro")
- `environment` (default: "dev")
- `vpc_id` (optional): VPC donde desplegar
- `subnet_id` (optional): Subnet específica

El módulo debe crear:
- Instancia EC2 con tags estándar
- Security Group con reglas básicas (SSH desde anywhere, HTTP, HTTPS)

El módulo debe output:
- `instance_id`
- `public_ip`
- `security_group_id`

### Parte 2: Usar el módulo 3 veces

En `main.tf` root, crear 3 instancias para diferentes servicios:

```hcl
module "web_server" {
  source = "./modules/ec2-service"

  service_name = "web"
  instance_type = "t3.small"
  environment = "production"
}

module "api_server" {
  source = "./modules/ec2-service"

  service_name = "api"
  instance_type = "t3.micro"
  environment = "production"
}

module "worker_server" {
  source = "./modules/ec2-service"

  service_name = "worker"
  instance_type = "t3.micro"
  environment = "production"
}
```

### Parte 3: Usar for_each (avanzado)

Crear las 3 instancias usando un map:

```hcl
variable "services" {
  type = map(object({
    instance_type = string
    environment   = string
  }))

  default = {
    web    = { instance_type = "t3.small", environment = "prod" }
    api    = { instance_type = "t3.micro", environment = "prod" }
    worker = { instance_type = "t3.micro", environment = "prod" }
  }
}

module "services" {
  source   = "./modules/ec2-service"
  for_each = var.services

  service_name  = each.key
  instance_type = each.value.instance_type
  environment   = each.value.environment
}
```

## 🎨 Archivos del módulo

```hcl
# modules/ec2-service/variables.tf
variable "service_name" {
  description = "Nombre del servicio (web, api, worker, etc)"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "ID de VPC (opcional)"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "ID de subnet (opcional)"
  type        = string
  default     = null
}
```

```hcl
# modules/ec2-service/main.tf
resource "aws_security_group" "service" {
  name        = "${var.service_name}-sg"
  description = "Security group for ${var.service_name} service"
  vpc_id      = var.vpc_id # or default VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service_name}-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_instance" "service" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.service.id]
  subnet_id             = var.subnet_id

  tags = {
    Name        = "${var.service_name}-${var.environment}"
    Service     = var.service_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
```

```hcl
# modules/ec2-service/outputs.tf
output "instance_id" {
  description = "ID de la instancia"
  value       = aws_instance.service.id
}

output "public_ip" {
  description = "IP pública"
  value       = aws_instance.service.public_ip
}

output "security_group_id" {
  description = "ID del security group"
  value       = aws_security_group.service.id
}
```

## ✅ Criterios de aceptación

- [ ] Módulo acepta parámetros configurables
- [ ] Módulo retorna información útil (outputs)
- [ ] Módulo es reutilizable (sin hardcoded values)
- [ ] Root module usa el módulo 3 veces
- [ ] Código es idempotente
- [ ] `terraform graph` muestra dependencias correctas

## 💡 Conceptos a aprender

- Module block y source
- Input variables en módulos
- Output values en módulos
- for_each vs count
- Module composition
- Best practices: naming, documentation

## 🔗 Recursos

- [Modules](https://www.terraform.io/docs/language/modules/index.html)
- [Module sources](https://www.terraform.io/docs/language/modules/sources.html)

## ⏱️ Tiempo estimado

60-90 minutos

## 💼 Reto: Versionado

El equipo quiere poder especificar una versión del módulo (como usar un release). Investiga cómo usar el módulo con versiones (sin usar registry, solo path local).