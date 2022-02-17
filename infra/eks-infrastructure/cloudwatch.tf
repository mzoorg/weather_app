data "kubectl_file_documents" "cw-manifests" {
    content = file("./cloudwatch-manifest/cwagent-fluent-bit.yaml")
}

resource "kubectl_manifest" "cloudwatch-tf" {
    for_each = data.kubectl_file_documents.cw-manifests.manifests
    yaml_body = each.value
}