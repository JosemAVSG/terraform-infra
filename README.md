# 🌍 Terraform Practice Challenges

Repositorio de práctica personal para mejorar mis habilidades con **Terraform (Infrastructure as Code)**.  
Cada carpeta contiene un **challenge** independiente con objetivos específicos, buenas prácticas y ejemplos reales de infraestructura reproducible.

---

## 🚀 Objetivos generales

- Aprender los fundamentos de Terraform (providers, recursos, variables, outputs).
- Dominar la modularización de la infraestructura.
- Aplicar buenas prácticas con `remote state`, `workspaces` y `pipelines CI/CD`.
- Practicar IaC en diferentes niveles de complejidad (de básico a avanzado).

---

## 📂 Estructura del repositorio
terraform-challenges/
│
├── challenge-01-basic-instance/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ ├── terraform.tfvars
│ └── README.md
│
├── challenge-02-variables-outputs-state/
│ ├── ...
│
├── challenge-03-modules/
│ ├── modules/
│ │ ├── network/
│ │ └── compute/
│ └── main.tf
│
├── challenge-04-sensitive-data/
│
├── challenge-05-full-infra/
│
└── challenge-06-workspaces/

Cada carpeta contiene su propio `README.md` explicando el reto, objetivos y pasos.

---

## 🧩 Lista de Challenges

| # | Challenge | Descripción | Nivel |
|---|------------|-------------|-------|
| 1 | **Basic Instance** | Crea tu primer recurso con variables y provider. | 🟢 Básico |
| 2 | **Variables & State** | Usa variables, outputs y backend remoto. | 🟢 Básico |
| 3 | **Modules** | Crea y consume módulos reutilizables. | 🟡 Intermedio |
| 4 | **Sensitive Data** | Maneja información sensible (contraseñas, secretos). | 🟡 Intermedio |
| 5 | **Full Infra** | Implementa una arquitectura completa (VPC + VM + DB). | 🔵 Avanzado |
| 6 | **Workspaces** | Gestiona múltiples entornos (dev, stage, prod). | 🔵 Avanzado |

---

## 🧠 Requisitos previos

- Terraform >= 1.6.0  
- Cuenta en un proveedor cloud (AWS / GCP / Azure)  
- Credenciales configuradas (por ejemplo con `aws configure` o variables de entorno)  
- Git instalado  
- (Opcional) Editor con soporte Terraform (VS Code + extensión HashiCorp)

---

## ⚙️ Comandos útiles

```bash
# Inicializar Terraform
terraform init

# Ver el plan de cambios
terraform plan

# Aplicar los cambios
terraform apply

# Destruir recursos
terraform destroy

# Validar formato y sintaxis
terraform fmt
terraform validate
