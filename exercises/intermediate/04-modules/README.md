# 🟡 Ejercicio 4: Módulos Reutilizables

## Objetivo
Crear y consumir módulos para organizar código y hacerlo reutilizable.

## Estructura propuesta
```
04-modules/
├── main.tf              # Uso del módulo
├── variables.tf         # Variables para el módulo
├── modules/
│   └── ec2-instance/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

## Tarea
1. Crea un módulo `modules/ec2-instance` que:
   - Acepta: `instance_name`, `instance_type`, `ami_id`
   - Retorna: `instance_id`, `public_ip`

2. En `main.tf`, usa el módulo 2 veces:
   - Instance A: "web-server", "t2.micro"
   - Instance B: "db-server", "t3.small"

3. Usa `for_each` o bloques dynamic para crear múltiples instancias

## Conceptos clave
- module block
- Input: `module.nombre.var`
- Output: `module.nombre.output`
- module path: `./modules/...`
- module version (para registry)

## Mejores prácticas
- Nombrado consistente
- Outputs mínimos necesarios
- Documentación en outputs

## Reto
Crear un módulo de VPC completo con subnets públicas y privadas