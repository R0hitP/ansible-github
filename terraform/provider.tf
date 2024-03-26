terraform {
  required_providers {
    ansible = {
      version = "~> 1.2.0"
      source  = "ansible/ansible"
    }
  }
}

provider "aws" {
  version = "~> 5.0"
  region  = "us-east-1"
}