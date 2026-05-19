# 🔵 Ejercicio 8: Arquitectura Completa

## Objetivo
Implementar una arquitectura de infraestructura completa con múltiples servicios.

## Arquitectura objetivo
```
┌─────────────────────────────────────────┐
│              VPC (10.0.0.0/16)           │
│                                          │
│  ┌─────────────┐    ┌────────────────┐  │
│  │ Public Subnet│    │ Private Subnet │  │
│  │ 10.0.1.0/24  │    │ 10.0.2.0/24    │  │
│  └─────────────┘    └────────────────┘  │
│         │                  │             │
│   ┌─────┴─────┐      ┌────┴─────────┐   │
│   │ ALB       │      │ EC2 Instances │   │
│   │ (80, 443) │─────▶│ (Auto Scaling)│   │
│   └───────────┘      └───────────────┘   │
│                              │            │
│                       ┌─────┴─────────┐   │
│                       │ RDS MySQL     │   │
│                       │ (Private DB)  │   │
│                       └───────────────┘   │
└─────────────────────────────────────────┘
```

## Tareas

### Módulo 1: VPC
- VPC con CIDR 10.0.0.0/16
- Internet Gateway
- 2 Public Subnets (AZ diferentes)
- 2 Private Subnets (AZ diferentes)
- Public Route Table
- Private Route Table

### Módulo 2: Security Groups
- ALB SG: puertos 80, 443
- App SG: puerto 8080, desde ALB SG
- DB SG: puerto 3306, desde App SG
- RDS Security Group

### Módulo 3: Application Layer
- Launch Template con user data
- Auto Scaling Group (min: 2, max: 4)
- Application Load Balancer
- Target Group

### Módulo 4: Database
- Subnet Group para RDS
- RDS MySQL (db.t3.micro)
- Secret en AWS Secrets Manager

## Estructura de módulos
```
08-complete-architecture/
├── main.tf
├── modules/
│   ├── vpc/
│   ├── security-groups/
│   ├── compute/
│   └── database/
```

## Conceptos clave
- Módulos root vs child
- Dependencias implícitas (implicit)
- Dependencias explícitas (depends_on)
- Data sources entre módulos

## Entregable final
Código funcional que cree toda la arquitectura con un solo `terraform apply`