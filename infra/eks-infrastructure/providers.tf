locals {
  region = "eu-central-1"
  tags = {
        Owner       = "egor_petrochenkov@epam.com"
        Environment = "test"
      }
}

terraform {
  required_version = ">= 0.15"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  config_path = "~/.kube/config_aws"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config_aws"
  }
}

provider "kubectl" {
  config_path = "~/.kube/config_aws"  
}