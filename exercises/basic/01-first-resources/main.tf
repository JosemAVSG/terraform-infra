# Provider configuration for Floci (local emulator)
# To use real AWS, remove the endpoints block and use real credentials

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

# Your first EC2 instance
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2
  instance_type = var.instance_type

  # Tags obligatorios según el ejercicio
  tags = {
    Name        = "mi-primera-instancia"
    Environment = "development"
    Department  = "engineering"
    Project     = "techstart-web"
    ManagedBy   = "terraform"
  }
}