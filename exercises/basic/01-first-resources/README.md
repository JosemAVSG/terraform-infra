# 🟢 Ejercicio 1: Tu Primera Instancia en la Nube

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Departamento:** Ingeniería  
**Solicitud:** "Necesitamos crear nuestro primer servidor en AWS para el entorno de desarrollo. Solo necesitamos algo básico para probar nuestra app."

## 🎯 Objetivo

Crear una instancia EC2 que simule un servidor de desarrollo. El equipo de devs necesita acceso SSH para configurar el entorno.

## 📋 Tu tarea

1. **Configurar el provider**:
   - Región: `us-east-1`
   - Credenciales via variables de entorno (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)

2. **Crear la instancia**:
   - AMI: Amazon Linux 2 (`ami-0c55b159cbfafe1f0`)
   - Tipo: `t2.micro` (incluido en Free Tier)
   - Key pair: `dev-key` (crear o usar existente)
   - Security Group: permitir SSH (puerto 22) desde tu IP

3. **Tags obligatorios**:
   ```
   Environment = "development"
   Department  = "engineering"
   Project     = "techstart-web"
   ManagedBy   = "terraform"
   ```

## 🎨 Archivos esperados

```
01-first-resources/
├── main.tf          # Provider + recurso
├── variables.tf     # Variables de configuración
├── outputs.tf       # Info de la instancia creada
└── versions.tf     # Versiones de Terraform y providers
```

## ✅ Criterios de aceptación

- [ ] Provider configurado correctamente
- [ ] Instancia creada con los tags correctos
- [ ] Output muestra ID e IP pública
- [ ] `terraform validate` pasa
- [ ] `terraform plan` muestra los cambios esperados

## 🧪 Con LocalStack

```hcl
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  s3_use_path_style           = true
  skip_credentials_validation = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}
```

## 💡 Conceptos a aprender

- Bloque `provider`
- Bloque `resource`
- Tags y metadatos
- Outputs para obtener información
- State local

## 🔗 Recursos

- [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [AWS Free Tier](https://aws.amazon.com/free/)

## ⏱️ Tiempo estimado

30-45 minutos