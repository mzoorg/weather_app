resource "helm_release" "jenkins-helm-1" {
  name       = "my-eks-jenkins"
  chart = "jenkins"
  repository = "https://charts.jenkins.io"
  version = "3.11.3"
  namespace = "devops"
  cleanup_on_fail = true

  values = [
    "${file("./jenkins-chart-val/values.yaml")}"
  ]
}