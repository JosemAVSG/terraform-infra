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

# EC2 Instance con variables
resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = var.instance_type

  # Tags dinámicos usando variables
  tags = {
    Name        = var.instance_name
    Environment = var.environment
    OwnerTeam   = var.owner_team
    ManagedBy   = "terraform"
  }
}