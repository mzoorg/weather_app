resource "kubernetes_namespace" "devops" {
  metadata {    
    name = "devops"
  }
}

resource "kubernetes_namespace" "test" {
  metadata {    
    name = "test"
  }
}

resource "kubernetes_namespace" "prod" {
  metadata {    
    name = "prod"
  }
}

resource "kubernetes_namespace" "amazon-cloudwatch" {
  metadata {    
    name = "amazon-cloudwatch"
  }
}