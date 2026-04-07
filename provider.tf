terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.34.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.8.1"

    }
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket-1996"
    dynamodb_table = "terraform-lock-table"
    key            = "jenkins-pipeline/terraform.tfstat"
    use_lockfile   = true
    encrypt        = true
    region         = "ap-south-1"
  }

}

  provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}
