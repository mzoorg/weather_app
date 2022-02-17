locals {
  myvars = {
    agent = {
      envVars = [
        {
          "name": "MYSQL_HOST",
          "value": "my-mysql-rds.cyivvsklcv5h.eu-central-1.rds.amazonaws.com:3306"
        },
        {
          "name": "ECR_REPO",
          "value": "156001095759.dkr.ecr.eu-central-1.amazonaws.com/weatherapp"
        }
      ]
    }
  }
}

resource "helm_release" "jenkins-helm-1" {
  name       = "my-eks-jenkins"
#  chart      = "https://github.com/jenkinsci/helm-charts/releases/download/jenkins-3.11.4/jenkins-3.11.4.tgz"
  chart = "jenkins"
  repository = "https://charts.jenkins.io"
  version = "3.11.3"
  namespace = "devops"
  cleanup_on_fail = true

  values = [
    "${file("./jenkins-chart-val/values.yaml")}"
  ]
}