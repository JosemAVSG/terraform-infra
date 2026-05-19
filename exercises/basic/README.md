# 🟢 Nivel Básico

Ejercicios para aprender los fundamentos de Terraform.

## 🏢 Contexto

**Empresa:** TechStart SA  
**Situación:** Empresa pequeña começando a adoptar Infrastructure as Code.

---

## Ejercicios

| # | Ejercicio | Descripción | Tiempo |
|---|-----------|-------------|--------|
| 01 | [First Resources](./01-first-resources/) | "Crear el primer servidor para devs" | 30-45 min |
| 02 | [Variables & Outputs](./02-variables-outputs/) | "Hacer el código reutilizable para diferentes ambientes" | 45-60 min |
| 03 | [Data Sources](./03-data-sources/) | "Buscar AMIs automáticamente sin hardcodear" | 30-45 min |

---

## Lo que aprenderás

- ✅ Provider configuration
- ✅ Resources básicos (EC2, etc.)
- ✅ Variables y outputs
- ✅ tfvars para configuración
- ✅ Data Sources para consultar info dinámica

---

## Requisitos

- Terraform >= 1.6
- AWS CLI configurado O LocalStack

## 💡 Con LocalStack

Podés usar LocalStack para todos estos ejercicios:

```bash
# Iniciar LocalStack
docker run -d -p 4566:4566 localstack/localstack

# Configurar provider
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  
  endpoints {
    ec2 = "http://localhost:4566"
  }
}
```

---

## 🎯 Objetivo del nivel

Al terminar, vas a poder crear infraestructura básica de AWS usando código versionable y reutilizable.