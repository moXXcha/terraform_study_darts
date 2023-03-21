#------------------------------
# Terraform configuration
#------------------------------
terraform {
  required_version = ">=0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

#------------------------------
# Provider
#------------------------------
provider "aws" {
  profile = "terraform_darts"
  region  = "ap-northeast-1"
}

#------------------------------
# Variables
#------------------------------
variable "project" {
  type = string
}
variable "env" {
  type = string
}