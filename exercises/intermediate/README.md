# 🟡 Nivel Intermedio

Ejercicios para crear código más robusto, reutilizable y preparado para equipos.

## 🏢 Contexto

**Empresa:** TechStart SA  
**Situación:** El equipo crece, necesitan estandarizar y trabajar en equipo sin conflictos.

---

## Ejercicios

| # | Ejercicio | Descripción | Tiempo |
|---|-----------|-------------|--------|
| 04 | [Modules](./04-modules/) | "Crear módulos reutilizables para que todo el equipo use" | 60-90 min |
| 05 | [Conditionals & Loops](./05-conditionals-loops/) | "Crear múltiples recursos dinámicamente según configuración" | 60-90 min |
| 06 | [Remote State](./06-remote-state/) | "Configurar state remoto para que el equipo comparta infraestructura" | 60-90 min |

---

## Lo que aprenderás

- ✅ Módulos propios (child modules)
- ✅ for_each, count, expressions
- ✅ Terraform functions (lookup, merge, etc)
- ✅ Remote backends (S3)
- ✅ State locking (DynamoDB)
- ✅ Workspaces basics

---

## Requisitos

- Completar nivel básico
- AWS CLI o **Floci**

## 💡 Con Floci

Todos estos ejercicios funcionan con Floci:

```bash
docker run --rm -p 4566:4566 floci/floci:latest
```

Floci soporta:
- ✅ S3 (backend de state)
- ✅ DynamoDB (state locking)
- ✅ VPC, EC2, Security Groups
- ✅ Lambdas (reales en Docker!)
- ✅ RDS (PostgreSQL/MySQL reales!)

---

## 🎯 Objetivo del nivel

Al terminar, vas a poder crear infraestructura compleja que se adapta a diferentes ambientes y puede ser mantenida por un equipo.