variable "cluster-name" {
  default = "cluster-eks-epetr"
  type    = string
}

variable "rds-test-name" {
  default = "mysql-test"
  type    = string
}

variable "rds-prod-name" {
  default = "mysql-prod"
  type    = string
}

variable "client-id" {
  type    = string
  sensitive = true
}