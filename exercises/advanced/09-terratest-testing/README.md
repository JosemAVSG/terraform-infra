# 🔵 Ejercicio 9: Testing con Terratest

## Objetivo
Aprender a escribir tests automatizados para infraestructura Terraform.

## Requisitos previos
- Go >= 1.18
- Terraform >= 1.0

## Estructura
```
09-terratest-testing/
├── main.tf              # Infra a testear
├── variables.tf
└── examples/
    └── basic_test.go    # Tests
```

## Tarea

### Parte 1: Test básico de instancia
1. Crea una instancia EC2 en main.tf
2. Escribe un test que verifique:
   - La instancia fue creada
   - El tipo es el correcto
   - Los tags son los esperados

### Parte 2: Test de atributos
```go
import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestEc2Instance(t *testing.T) {
    terraformOptions := &terraform.Options{
        TerraformDir: ".",
    }

    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    instanceID := terraform.Output(t, terraformOptions, "instance_id")
    assert.NotEmpty(t, instanceID)
}
```

### Parte 3: Test de validación
- Valida que el plan sea válido
- Verifica outputs requeridos
- Test de idempotencia (apply dos veces)

## Conceptos clave
- `terratest` package
- `terraform.Options`
- `terraform.InitAndApply`
- `terraform.Destroy` (defer)
- Assertions con `testify`

## Comandos
```bash
go mod init tests
go get github.com/gruntwork-io/terratest/modules/terraform
go test -v -timeout 30m
```

## Reto avanzado
Escribir tests para:
- Múltiples instancias con for_each
- SG con reglas específicas
- Validación de outputs con regex