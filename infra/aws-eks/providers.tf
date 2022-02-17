locals {
  region = "eu-central-1"
  tags = {
        Owner       = "egor_petrochenkov@epam.com"
        Environment = "test"
      }
}

terraform {
  required_version = ">= 0.15"
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  config_path = "~/.kube/config_aws"
}

# data "aws_region" "current" {
# }

# data "aws_availability_zones" "available" {
# }

# provider "http" {
# }

