terraform {
  required_providers {
    ansible = {
      version = "~> 1.2.0"
      source  = "ansible/ansible"
    }
    aws = {
      version = "~> 5.0"
      source  = "hashicorp/aws"
      region = "us-east-1"
    }
  }
}
