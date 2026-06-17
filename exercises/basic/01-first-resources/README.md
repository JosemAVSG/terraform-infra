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

## 🧪 Con Floci (emulador local)

Floci es más rápido y liviano que LocalStack, y tiene más servicios reales.

```bash
# Iniciar Floci
docker run --rm -p 4566:4566 floci/floci:latest
```

```hcl
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}
```

**Nota:** Floci emula EC2 a nivel de API, Para testing de integración real, usa AWS real o considera que algunos servicios tienen limitaciones.

## 💡 Conceptos a aprender

- Bloque `provider`
- Bloque `resource`
- Tags y metadatos
- Outputs para obtener información
- State local

## 🔗 Recursos

- [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Floci](https://floci.io/)
- [AWS Free Tier](https://aws.amazon.com/free/)

## ⏱️ Tiempo estimado

30-45 minutos