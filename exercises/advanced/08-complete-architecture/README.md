# 🔵 Ejercicio 8: Arquitectura Completa de Producción

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Solicitud:** "Necesitamos migrar nuestra app a AWS con una arquitectura robusta: VPC propia, múltiples AZs, Load Balancer, Auto Scaling, y base de datos gestionada. Todo con Terraform."

## 🎯 Objetivo

Implementar una arquitectura completa lista para producción, usando módulos organizados.

## 📋 Arquitectura objetivo

```
┌─────────────────────────────────────────────────────────────────────┐
│                              VPC (10.0.0.0/16)                       │
│                                                                         │
│  ┌─────────────────────────────────────────────────────────────────┐  │
│  │                    Public Subnets (AZ-a, AZ-b)                 │  │
│  │  10.0.1.0/24  │  10.0.2.0/24                                    │  │
│  │                                                                │  │
│  │   ┌─────────┐                                                 │  │
│  │   │  ALB   │  :80, :443                                        │  │
│  │   └────┬────┘                                                 │  │
│  └────────┼───────────────────────────────────────────────────────┘  │
│           │                                                             │
│  ┌────────┴───────────────────────────────────────────────────────┐  │
│  │                   Private Subnets (AZ-a, AZ-b)                   │  │
│  │  10.0.11.0/24 │ 10.0.12.0/24                                   │  │
│  │                                                                 │  │
│  │   ┌─────────────┐  ┌─────────────┐                               │  │
│  │   │ EC2 (ASG)  │  │ EC2 (ASG)  │  │  Auto Scaling Group       │  │
│  │   │ min:2,max:4│  │ min:2,max:4│  │  Port 8080               │  │
│  │   └─────────────┘  └─────────────┘                               │  │
│  │         │                  │                                      │  │
│  └─────────┼──────────────────┼──────────────────────────────────────┘  │
│            │                  │                                        │
│  ┌─────────┴──────────────────┴──────────────────────────────────────┐  │
│  │                     Private Subnet (DB)                         │  │
│  │  10.0.21.0/24 │ 10.0.22.0/24                                   │  │
│  │                                                                │  │
│  │   ┌─────────────┐                                               │  │
│  │   │   RDS MySQL │  db.t3.micro                                  │  │
│  │   │   Multi-AZ │  Port 3306                                     │  │
│  │   └─────────────┘                                               │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│  Security Groups: ALB → App → DB                                       │
└─────────────────────────────────────────────────────────────────────┘
```

## 📋 Tareas por módulo

### Módulo 1: VPC (`modules/vpc/`)

```hcl
# VPC principal
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.common_tags
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = var.common_tags
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = toset(var.availability_zones)
  
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, index(var.availability_zones, each.value))
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { Type = "public" })
}

# Private Subnets (App)
resource "aws_subnet" "private_app" {
  for_each = toset(var.availability_zones)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, length(var.availability_zones) + index(var.availability_zones, each.value))
  availability_zone = each.value

  tags = merge(var.common_tags, { Type = "private-app" })
}

# Private Subnets (DB)
resource "aws_subnet" "private_db" {
  for_each = toset(var.availability_zones)
  
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, 2 * length(var.availability_zones) + index(var.availability_zones, each.value))
  availability_zone = each.value

  tags = merge(var.common_tags, { Type = "private-db" })
}

# Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = var.common_tags
}

# NAT Gateway (una por AZ en producción)
resource "aws_nat_gateway" "main" {
  for_each = toset(var.availability_zones)
  
  allocation_id = aws_eip.nat[each.key].id
  subnet_id    = aws_subnet.public[each.key].id

  tags = var.common_tags
}
```

### Módulo 2: Security Groups (`modules/security-groups/`)

```hcl
# ALB Security Group
resource "aws_security_group" "alb" {
  name        = "${var.prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

# App Security Group
resource "aws_security_group" "app" {
  name        = "${var.prefix}-app-sg"
  description = "Security group for app servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]  # Solo desde dentro de VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.common_tags
}

# DB Security Group
resource "aws_security_group" "db" {
  name        = "${var.prefix}-db-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  tags = var.common_tags
}
```

### Módulo 3: Compute - ASG (`modules/compute/`)

```hcl
# Launch Template
resource "aws_launch_template" "app" {
  name_prefix   = "${var.prefix}-app-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair

  vpc_security_group_ids = [var.app_security_group_id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              systemctl start docker
              docker run -d -p 8080:8080 ${var.app_image}
              EOF  )

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.common_tags, { Name = "${var.prefix}-app" })
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app" {
  name                = "${var.prefix}-asg"
  vpc_zone_identifier = var.subnet_ids
  desired_capacity   = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  health_check_type   = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.prefix}-app"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}

# Target Group
resource "aws_lb_target_group" "app" {
  name     = "${prefix}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }
}

# ALB
resource "aws_lb" "app" {
  name               = "${prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = var.common_tags
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
```

### Módulo 4: Database (`modules/database/`)

```hcl
# Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.prefix}-db-subnet"
  subnet_ids = var.subnet_ids

  tags = var.common_tags
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier     = "${var.prefix}-mysql"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.instance_class

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "mon:04:00-mon:05:00"

  deletion_protection = var.environment == "prod" ? true : false
  skip_final_snapshot = var.environment != "prod" ? true : false

  tags = var.common_tags
}
```

## 🎨 Estructura final

```
08-complete-architecture/
├── main.tf                      # Root module
├── variables.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars             # Configuración por defecto
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security-groups/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── compute/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── database/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## ✅ Criterios de aceptación

- [ ] VPC con 3 tipos de subnets (public, private-app, private-db)
- [ ] NAT Gateway para outbound desde subnets privadas
- [ ] Security Groups: ALB → App → DB
- [ ] Auto Scaling Group con Launch Template
- [ ] Application Load Balancer con Target Group
- [ ] RDS MySQL en subnets privadas
- [ ] Módulos separados y reutilizables
- [ ] Outputs útiles en cada módulo
- [ ] Todo despliega con un solo `terraform apply`

## 📋 Variables del root module

```hcl
# variables.tf
variable "environment" {
  description = "dev, staging, prod"
  type       = string
}

variable "aws_region" {
  description = "AWS region"
  type       = string
  default    = "us-east-1"
}

# Configuración de compute
variable "instance_type" {
  description = "EC2 instance type"
  type       = string
  default    = "t3.small"
}

variable "asg_min_size" {
  description = "ASG minimum size"
  type       = number
  default    = 2
}

variable "asg_max_size" {
  description = "ASG maximum size"
  type       = number
  default    = 4
}

# Configuración de DB
variable "db_instance_class" {
  description = "RDS instance class"
  type       = string
  default    = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type       = string
  default    = "techstart"
}

variable "db_username" {
  description = "Database username"
  type       = string
  default    = "admin"
}

variable "db_password" {
  description = "Database password"
  type       = string
  sensitive  = true
}
```

## ⚠️ Preocupaciones de seguridad

1. **Secrets** - No hardcodear passwords, usar AWS Secrets Manager
2. **SSH** - Limitar acceso a Bastion o Session Manager
3. **RDS** - Enable encryption at rest
4. **ALB** - Considerar HTTPS con ACM
5. **VPC** - Restringir Security Groups al mínimo necesario

## 🔗 Recursos

- [VPC module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
- [ALB module](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/latest)
- [RDS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)

## ⏱️ Tiempo estimado

3-5 horas

## 💼 Reto: 添加 más servicios

Agregar al diseño:
1. CloudWatch para logs
2. SNS para alertas de ASG
3. ElastiCache Redis
4. S3 para static assets