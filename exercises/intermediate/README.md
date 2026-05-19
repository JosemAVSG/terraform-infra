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
- ✅ Terraform functions (lookup, merge, etc.)
- ✅ Remote backends (S3)
- ✅ State locking (DynamoDB)
- ✅ Workspaces basics

---

## Requisitos

- Completar nivel básico
- AWS CLI o LocalStack
- (Para ejercicio 6) Bucket S3 o LocalStack

## 💡 Aplicación real

Estos patrones se usan en proyectos reales:
- **Módulos** → Componentes reutilizables en toda la empresa
- **Conditionals** → Infrastructure as Code dinámico
- **Remote state** → Equipos de +3 personas trabajando juntos

---

## 🎯 Objetivo del nivel

Al terminar, vas a poder crear infraestructura compleja que se adapta a diferentes ambientes y puede ser mantenida por un equipo.