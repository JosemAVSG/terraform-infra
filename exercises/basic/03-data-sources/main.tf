# Provider for Floci
provider "aws" {
  region                      = var.aws_region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}

# Data Source: Buscar AMI más reciente de Amazon Linux 2
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Data Source: Obtener región actual
data "aws_region" "current" {}

# Data Source: Listar Availability Zones disponibles
data "aws_availability_zones" "available" {
  state = "available"
}

# Instancia usando los datos obtenidos
resource "aws_instance" "app" {
  # Usar la AMI del data source - NO hardcoded!
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  tags = {
    Name        = "app-with-datasource"
    Environment = var.environment
    AmiUsed     = data.aws_ami.amazon_linux.name
    Region      = data.aws_region.current.name
  }
}