resource "helm_release" "sonar-helm-1" {
  name       = "my-eks-sonar"
#  chart      = "https://github.com/Oteemo/charts/releases/download/sonarqube-9.10.0/sonarqube-9.10.0.tgz"
  chart = "sonarqube"
  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  version = "1.2.5+179"
  namespace = "devops"
  cleanup_on_fail = true

  values = [
    "${file("./sonar-chart-val/values.yaml")}"
  ]
}