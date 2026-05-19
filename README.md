# 🌍 Terraform Practice Repository

Mi repositorio personal para practicar **Terraform (Infrastructure as Code)**.

---

## 📁 Estructura del Repositorio

```
terraform-infra/
├── exercises/              # Ejercicios organizados por nivel
│   ├── basic/             # 🟢 Nivel Básico
│   │   ├── 01-first-resources/
│   │   ├── 02-variables-outputs/
│   │   └── 03-data-sources/
│   ├── intermediate/      # 🟡 Nivel Intermedio
│   │   ├── 04-modules/
│   │   ├── 05-conditionals-loops/
│   │   └── 06-remote-state/
│   └── advanced/          # 🔵 Nivel Avanzado
│       ├── 07-workspaces/
│       ├── 08-complete-architecture/
│       └── 09-terratest-testing/
├── terraform-challenge-1/ # Desafíos completados
└── README.md
```

---

## 🧩 Ejercicios por Nivel

### 🟢 Nivel Básico

| # | Ejercicio | Conceptos |
|---|-----------|-----------|
| 01 | [First Resources](./exercises/basic/01-first-resources/) | Provider, resources, básica estructura |
| 02 | [Variables & Outputs](./exercises/basic/02-variables-outputs/) | Variables, outputs, tfvars |
| 03 | [Data Sources](./exercises/basic/03-data-sources/) | Data sources, filtering |

**Duración estimada:** 1-2 horas por ejercicio

---

### 🟡 Nivel Intermedio

| # | Ejercicio | Conceptos |
|---|-----------|-----------|
| 04 | [Modules](./exercises/intermediate/04-modules/) | Módulos reutilizables |
| 05 | [Conditionals & Loops](./exercises/intermediate/05-conditionals-loops/) | for_each, count, ternary |
| 06 | [Remote State](./exercises/intermediate/06-remote-state/) | S3 backend, state locking |

**Duración estimada:** 2-3 horas por ejercicio

---

### 🔵 Nivel Avanzado

| # | Ejercicio | Conceptos |
|---|-----------|-----------|
| 07 | [Workspaces](./exercises/advanced/07-workspaces/) | Multi-environment management |
| 08 | [Complete Architecture](./exercises/advanced/08-complete-architecture/) | VPC, ALB, ASG, RDS |
| 09 | [Terratest](./exercises/advanced/09-terratest-testing/) | Testing automatizado |

**Duración estimada:** 3-5 horas por ejercicio

---

## 🚀 Cómo usar este repositorio

1. **Para cada ejercicio:**
   - Lee el README del ejercicio
   - Crea los archivos solicitados
   - Ejecuta `terraform init` → `terraform validate` → `terraform plan`

2. **Orden recomendado:**
   - Empieza por nivel básico (ejercicio 1)
   - Completa los 3 ejercicios básicos antes de avanzar
   - Los ejercicios dependen del conocimiento previo

3. **Desafíos:**
   - Los desafíos en `terraform-challenge-X/` son proyectos independientes
   - Cada challenge tiene objetivos específicos

---

## 🛠️ Requisitos previos

- **Terraform** >= 1.6.0
- **AWS CLI** (o GCP/Azure CLI según ejercicio)
- **Git** instalado
- **Editor** con soporte Terraform (VS Code + HashiCorp Terraform)

### Para nivel avanzado (Terratest):
- **Go** >= 1.18

---

## 📋 Comandos útiles

```bash
# Inicializar proyecto
terraform init

# Validar sintaxis
terraform validate

# Ver plan de cambios
terraform plan

# Aplicar cambios
terraform apply
terraform apply -var-file="env.tfvars"

# Destruir recursos
terraform destroy

# Formatear código
terraform fmt

# Ver outputs
terraform output

# Workspaces
terraform workspace new dev
terraform workspace select prod
terraform workspace list
```

---

## 🎯 Objetivos de aprendizaje

- [x] Fundamentos de Terraform (providers, resources, variables)
- [ ] Módulos reutilizables
- [ ] Remote state y backends
- [ ] Multi-environment con workspaces
- [ ] Arquitectura completa de infraestructura
- [ ] Testing automatizado

---

## 📚 Recursos adicionales

- [Documentación oficial de Terraform](https://www.terraform.io/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [AWS Provider docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terratest](https://terratest.gruntwork.io/)

---

## Licencia

MIT