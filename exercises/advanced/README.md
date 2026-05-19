# 🔵 Nivel Avanzado

Proyectos completos que integran múltiples conceptos para arquitecturas de producción.

## 🏢 Contexto

**Empresa:** TechStart SA  
**Situación:** Escala a producción con múltiples ambientes, arquitectura robusta y testing automatizado.

---

## Ejercicios

| # | Ejercicio | Descripción | Tiempo |
|---|-----------|-------------|--------|
| 07 | [Workspaces](./07-workspaces/) | "Gestionar dev, staging, prod con el mismo código" | 60-90 min |
| 08 | [Complete Architecture](./08-complete-architecture/) | "VPC + ALB + ASG + RDS - Arquitectura completa" | 3-5 horas |
| 09 | [Terratest](./09-terratest-testing/) | "Tests automatizados antes de hacer apply" | 2-3 horas |

---

## Lo que aprenderás

- ✅ Multi-environment management
- ✅ Workspaces vs directorios
- ✅ Arquitectura de referencia completa
- ✅ Módulos organizados a escala
- ✅ Testing de infraestructura (TDD)
- ✅ CI/CD básico

---

## Requisitos

- Completar niveles básico e intermedio
- Go >= 1.18 (para Terratest)
- Floci para testing local (no requiere AWS real)

## 💡 Flujo recomendado

```
┌─────────────────────────────────────────────────────────────┐
│  DESARROLLO LOCAL (Floci)                                   │
│  - Ejercicios 1-8 con Floci                                │
│  - No necesitas cuenta de AWS                              │
│  - Todo corre en tu máquina                                │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  TESTING REAL (AWS real)                                   │
│  - Ejercicio 9 (Terratest)                                 │
│  - Requiere cuenta AWS real                                │
│  - Crea y destruye recursos reales                         │
└─────────────────────────────────────────────────────────────┘
```

## 🎯 Objetivo del nivel

Al terminar, vas a tener una arquitectura completa lista para producción que podés mostrar como portfolio.

---

## 🚀 Proyecto final

El ejercicio **08-complete-architecture** es el proyecto final: una arquitectura completa con:
- VPC propia
- Múltiples AZs
- ALB + Auto Scaling
- RDS MySQL
- Módulos organizados

Es el equivalente a lo que vas a usar en un trabajo real.

---

## 🧪 Con Floci

Floci soporta los servicios necesarios para los ejercicios avanzados:

```bash
docker run --rm -p 4566:4566 floci/floci:latest
```

| Servicio | Soportado | Notas |
|----------|-----------|-------|
| VPC | ✅ | Subnets, Route Tables, IGW |
| EC2 | ✅ | Instancias, Security Groups |
| ALB | ✅ | Load Balancers, Target Groups |
| ASG | ✅ | Launch Templates, ASG |
| RDS | ✅ | PostgreSQL/MySQL reales en Docker |
| Lambda | ✅ | Funciones reales en Docker |
| S3 | ✅ | Buckets, versioning |
| DynamoDB | ✅ | Tablas, streams |