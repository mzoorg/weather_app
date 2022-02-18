data "kubectl_file_documents" "jenkins-agent-manifests" {
    content = file("./jenkins-manifest/jenkins-agent-sa.yaml")
}

resource "kubectl_manifest" "jenkins-agent-tf" {
    for_each = data.kubectl_file_documents.jenkins-agent-manifests.manifests
    yaml_body = each.value
}