# 🔵 Ejercicio 9: Testing Automatizado con Terratest

## 🏢 Contexto empresarial

**Empresa:** TechStart SA  
**Problema:**
- "Hicimos un cambio y rompimos producción"
- "No hay forma de saber si el código funciona hasta hacer apply"
- "Necesitamos CI/CD que valide antes de aplicar"

## 🎯 Objetivo

Escribir tests automatizados que validen la infraestructura antes de hacer apply.

## 📋 Requisitos previos

```bash
# Instalar Go
brew install go

# Verificar versión
go version
# go1.21+
```

## 📋 Tu tarea

### Estructura del proyecto

```
09-terratest-testing/
├── main.tf              # Infra a testear
├── variables.tf
├── outputs.tf
└── examples/
    ├── basic_test.go    # Test básico
    ├── ec2_test.go      # Test de instancia
    └── sg_test.go       # Test de security group
```

### Parte 1:Infraestructura a testear

**main.tf:**
```hcl
terraform {
  required_version = ">= 1.0"
}

provider "aws" {
  region = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  tags = {
    Name        = "test-instance"
    Environment = "test"
  }
}

output "instance_id" {
  value = aws_instance.app.id
}

output "instance_type" {
  value = aws_instance.app.instance_type
}

output "instance_state" {
  value = aws_instance.app.instance_state
}
```

### Parte 2: Test básico de instancia

```go
// examples/basic_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestEc2Instance(t *testing.T) {
    t.Parallel()

    // Configurar opciones de Terraform
    terraformOptions := &terraform.Options{
        TerraformDir: "..",
        Vars: map[string]interface{}{
            "instance_type": "t3.micro",
        },
    }

    // Cleanup al final del test
    defer terraform.Destroy(t, terraformOptions)

    // Init y Apply
    terraform.InitAndApply(t, terraformOptions)

    // Obtener outputs
    instanceID := terraform.Output(t, terraformOptions, "instance_id")
    instanceType := terraform.Output(t, terraformOptions, "instance_type")
    instanceState := terraform.Output(t, terraformOptions, "instance_state")

    // Assertions
    assert.NotEmpty(t, instanceID, "Instance ID should not be empty")
    assert.Equal(t, "t3.micro", instanceType, "Instance type should match")
    assert.Equal(t, "running", instanceState, "Instance should be running")
}
```

### Parte 3: Test de múltiples recursos

```go
// examples/multi_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestMultipleInstances(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "..",
        Vars: map[string]interface{}{
            "instance_count": 3,
        },
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    // Obtener lista de IDs
    instanceIDs := terraform.OutputList(t, terraformOptions, "instance_ids")
    
    assert.Equal(t, 3, len(instanceIDs), "Should have 3 instances")
    
    for _, id := range instanceIDs {
        assert.NotEmpty(t, id, "Each instance ID should not be empty")
    }
}
```

### Parte 4: Test de validación

```go
// examples/validation_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
    "fmt"
)

func TestValidateTerraform(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "..",
    }

    // Validar que el código es válido
    assert.True(t, terraform.Validate(t, terraformOptions), "Terraform should be valid")
    
    // Validar formato
    assert.True(t, terraform.Fmt(t, terraformOptions), "Terraform should be formatted")
    
    // Plan debe ser exitoso
    plan := terraform.InitAndPlan(t, terraformOptions)
    assert.Contains(t, plan, "Plan: 1 to add", "Plan should show resources to create")
}
```

### Parte 5: Test con for_each

Asumiendo que el main.tf tiene:

```hcl
variable "servers" {
  type = map(object({
    type  = string
    env   = string
  }))
  
  default = {
    web = { type = "t3.small", env = "prod" }
    api = { type = "t3.micro", env = "prod" }
  }
}

resource "aws_instance" "server" {
  for_each = var.servers
  
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = each.value.type
  
  tags = {
    Name = each.key
    Env  = each.value.env
  }
}

output "server_names" {
  value = keys(aws_instance.server)
}
```

El test:

```go
func TestForEachInstances(t *testing.T) {
    t.Parallel()

    terraformOptions := &terraform.Options{
        TerraformDir: "..",
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    serverNames := terraform.OutputList(t, terraformOptions, "server_names")
    
    assert.Contains(t, serverNames, "web", "Should contain web server")
    assert.Contains(t, serverNames, "api", "Should contain api server")
}
```

## 🎨 Archivos esperados

```
09-terratest-testing/
├── main.tf
├── variables.tf
├── outputs.tf
├── go.mod                # Módulo Go
├── go.sum
└── examples/
    ├── basic_test.go
    ├── ec2_test.go
    ├── validation_test.go
    └── for_each_test.go
```

## ✅ Criterios de aceptación

- [ ] Test crea infraestructura exitosamente
- [ ] Test valida outputs correctamente
- [ ] Test limpieza (destroy) funciona
- [ ] Tests son paralelizables (t.Parallel())
- [ ] Timeout configurado para tests largos

## 📋 Comandos

```bash
# Inicializar proyecto Go
cd 09-terratest-testing
go mod init tests
go mod tidy

# Instalar Terratest
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/stretchr/testify

# Ejecutar tests
go test -v -timeout 30m

# Con specific test
go test -v -run TestEc2Instance -timeout 10m
```

## 💡 Conceptos a aprender

- Terratest framework
- terraform.Options
- Assertions con testify
- Test parallelization
- Cleanup con defer
- Terraform validation

## ⚠️ Costos

**Warning:** Estos tests crean y destruyen recursos en AWS. 
- Ejecutar en cuenta de dev/staging
- Usar `t.Skip()` para skippar tests si es necesario
- Timeout adecuado para evitar recursos huérfanos

## 🔗 Recursos

- [Terratest](https://terratest.gruntwork.io/)
- [Terratest Terraform](https://pkg.go.dev/github.com/gruntwork-io/terratest/modules/terraform)
- [Testify](https://github.com/stretchr/testify)

## ⏱️ Tiempo estimado

2-3 horas

## 💼 Reto: Integration Test

Crear un test que:
1. Cree una instancia
2. Use AWS SDK para verificar que está corriendo
3. Use SSH para ejecutar un comando
4. Verifique los logs

Hint: Usa el paquete `modules/ssh` de Terratest.