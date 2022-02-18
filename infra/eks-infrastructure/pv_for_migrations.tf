data "kubectl_file_documents" "pv-app-manifest" {
    content = file("./pv-app-manifest/pv-manifest.yaml")
}

resource "kubectl_manifest" "pv-app-manifest-tf" {
    for_each = data.kubectl_file_documents.pv-app-manifest.manifests
    yaml_body = each.value
}